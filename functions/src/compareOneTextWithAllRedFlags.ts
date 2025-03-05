/**
 * Import function triggers from their respective submodules:
 *
 * import { onRequest } from "firebase-functions/v2/https";
 * import { onDocumentWritten } from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

import {onRequest} from "firebase-functions/v2/https";
import {defineSecret} from "firebase-functions/params";
import fetch from "node-fetch";

// (示意) 以 Pinecone search 取代你手動 loop
import {Pinecone} from "@pinecone-database/pinecone";
import type {Index} from "@pinecone-database/pinecone";

/**
 * Pinecone 用 lazy-init 方式管理，避免多次建立。
 */
let pinecone: Pinecone | null = null;

/**
 * getPineconeClient
 * 取得 Pinecone 的客戶端實例 (Lazy-init)。
 *
 * @return {Pinecone} Pinecone 客戶端
 */
function getPineconeClient() {
  if (!pinecone) {
    // 直接在建構子中指定 apiKey, environment
    pinecone = new Pinecone({
      apiKey: "pcsk_43HmKS_T75Y6T2mtDpcEFy8QaCtsyHfFWKhZL7SDdeEFRRodRa9znBV3RDFbMeZ73J9ZJg",
    });
  }
  return pinecone;
}

/**
 * 連接 (或取得) Pinecone 中的 "red-index" 索引。
 * @return {Index} - 指定索引的操作物件
 */
function getPineconeIndex(): Index {
  const client = getPineconeClient();
  return client.index("red-index");// 注意：新版是 .index(...) 不是 .Index(...)
}

// 取得 OpenAI API Key，建議在 Firebase Secrets 管理中設定
const openAiApiKey = defineSecret("OPENAI_API_KEY");

/**
 * getEmbeddingForText
 * 呼叫 OpenAI 取得文字的 Embedding。
 *
 * @param {string} text  要產生向量的文字
 * @param {string} apiKey OpenAI API Key
 * @return {Promise<number[] | null>} 成功則回傳向量陣列，失敗回傳 null
 */
async function getEmbeddingForText(text: string, apiKey: string): Promise<number[] | null> {
  if (!apiKey) {
    console.error("尚未設定 OPENAI_API_KEY");
    return null;
  }

  try {
    const res = await fetch("https://api.openai.com/v1/embeddings", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${apiKey}`,
      },
      body: JSON.stringify({
        input: text,
        model: "text-embedding-ada-002",
      }),
    });

    if (!res.ok) {
      const errorText = await res.text();
      console.error("OpenAI API Error:", errorText);
      return null;
    }

    const json = await res.json();
    const vector = json.data?.[0]?.embedding;
    if (!Array.isArray(vector)) {
      console.error("無法取得 embedding");
      return null;
    }

    return vector;
  } catch (err) {
    console.error("fetch error:", err);
    return null;
  }
}

/**
 * compareOneTextWithAllRedFlags:
 * 1) 從 req.query.text / req.body.text 拿到「使用者輸入的文字」
 * 2) 用 OpenAI 產生該文字的 embedding
 * 3) 讀取 Firestore: doc("embeddings/red_flags") => data() => 逐一對比
 * 4) 計算 cosSim，收集結果 => 回傳
 *
 * 這樣你就能對 DB 裡所有句子的 embedding 做一次比對
 */
export const compareOneTextWithAllRedFlags = onRequest(
  {
    secrets: [openAiApiKey],
    timeoutSeconds: 300,
  },
  async (req, res): Promise<void> => {
    try {
      const text = (req.query.text as string) || req.body.text;
      if (!text) {
        res.status(400).json({
          input: null,
          category: null,
          top: {sentence: null, similarity: null},
          error: "Missing text",
        });
        return;
      }

      // **(A) 三條規則：**
      // 1) "我不值得"
      const patternDirect = /我\s*不值得/i;

      // 2) "我(覺得|感覺|認為)不值得"
      const patternOpinion = /我\s*(覺得|感覺|認為).*不值得/i;

      // 3) "我不覺得值得" (只允許空白)，排除 "我不覺得我值得"
      const patternNoThinkWorth = /我\s*不(覺得|感覺|認為).*值得/i;

      let sentenceCategory: "none"|"direct"|"opinion" = "none";

      if (patternDirect.test(text)) {
        sentenceCategory = "direct"; // "我不值得"
      } else if (patternOpinion.test(text)) {
        sentenceCategory = "opinion";
        // 壓縮空白和大小寫
        const compressed = text.toLowerCase().replace(/\s+/g, "");
        // 如果剛好等於 "我覺得我不值得"，就不排除
        if (/^我(?:覺得|感覺|認為)我不值得$/.test(compressed)) {
          // 這裡可視需求給一個特殊 category 
          // sentenceCategory = "worth_myself" (隨意命名)
          // 不做任何提前 return
        } else {
          // 其餘情況 => 排除
          res.json({
            input: text,
            category: sentenceCategory, // 可能 still "none"
            top: {
              sentence: null,
              similarity: null,
            },
            error: null,
            note: "Skipped Pinecone search due to match: [我覺得 XXX 不值得] except [我覺得我不值得]",
          });
          return;
        }
      } else if (patternNoThinkWorth.test(text)) {
        sentenceCategory = "opinion";
        // 壓縮空白和大小寫
        const compressed = text.toLowerCase().replace(/\s+/g, "");
        // 如果剛好等於 "我不覺得我值得"，就不排除
        if (/^我不(?:覺得|感覺|認為)我值得$/.test(compressed)) {
          // 這裡可視需求給一個特殊 category 
          // sentenceCategory = "worth_myself" (隨意命名)
          // 不做任何提前 return
        } else {
          // 其餘情況 => 排除
          res.json({
            input: text,
            category: sentenceCategory, // 可能 still "none"
            top: {
              sentence: null,
              similarity: null,
            },
            error: null,
            note: "Skipped Pinecone search due to match: [我不覺得 XXX 值得] except [我不覺得我值得]",
          });
          return;
        }
      }

      // **(B) 產生查詢向量 embed
      const apiKey = openAiApiKey.value();
      const embed = await getEmbeddingForText(text, apiKey);
      if (!embed) {
        res.status(500).json({
          input: text,
          category: sentenceCategory,
          top: {sentence: null, similarity: null},
          error: "Failed to get OpenAI embedding",
        });
        return;
      }

      // (C) Pinecone 做 ANN 查詢 topK=1
      const index = await getPineconeIndex();// Lazy init
      const queryResponse = await index.query({
        vector: embed,
        topK: 1,
        includeValues: false,
        includeMetadata: true,
      });

      // queryResponse 會帶回 matches array, e.g. [{ id: "sentence1", score: 0.923, ... }, ...]
      if (!queryResponse.matches || queryResponse.matches.length === 0) {
        res.json({
          input: text,
          category: sentenceCategory, // 回傳分辨結果
          top: {
            sentence: null,
            similarity: null,
          },
          error: null,
        });
        return;
      }

      const topMatch = queryResponse.matches[0];
      res.json({
        input: text,
        category: sentenceCategory, // 回傳你區分的結果
        top: {
          sentence: topMatch.id, // 之前 upsert 的 sentence
          similarity: topMatch.score, // Pinecone score ( ~ cosSim)
          // 取 metadata 裡的 original_text
          original_text: topMatch.metadata?.original_text || null,
        },
        error: null,
      });
      return;
    } catch (err: unknown) {
      console.error("ANN error:", err);
      res.status(500).json({
        input: null,
        category: null,
        top: {
          sentence: null,
          similarity: null,
        },
        error: err instanceof Error ? err.message : String(err),
      });
      return;
    }
  }
);
