/**
 * compareOneTextWithAllRelationshipInquiries.ts
 * ---------------------------------------------
 * 這個 Cloud Function 用於接收一段文字，判斷是否屬於「relationship inquiry」類型，
 * 並透過 Pinecone 搜尋最相似的已上傳句子 (例如：你有男朋友嗎？你是不是單身？等等)。
 */

import {onRequest} from "firebase-functions/v2/https";
import {defineSecret} from "firebase-functions/params";
import fetch from "node-fetch";

import {Pinecone} from "@pinecone-database/pinecone";
import type {Index} from "@pinecone-database/pinecone";

let pinecone: Pinecone | null = null;
function getPineconeClient() {
  if (!pinecone) {
    pinecone = new Pinecone({
      apiKey: "pcsk_43HmKS_T75Y6T2mtDpcEFy8QaCtsyHfFWKhZL7SDdeEFRRodRa9znBV3RDFbMeZ73J9ZJg",
      // 如果有設定 environment，也要在這裡指定
      // e.g. environment: "us-east1-gcp"
    });
  }
  return pinecone;
}

function getPineconeIndex(): Index {
  const client = getPineconeClient();
  return client.index("red-index"); // 假設你還是用 red-index，如果想分開，可改別的名稱
}

// 透過 Firebase Secrets 管理 OpenAI API Key
const openAiApiKey = defineSecret("OPENAI_API_KEY");

/**
 * 取得文字的 embedding
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
        model: "text-embedding-3-large", // 你可以使用 large 或其他模型
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
 * compareOneTextWithAllRelationshipInquiries:
 * 1) 從 req.query.text / req.body.text 拿到「使用者輸入的文字」
 * 2) 用 OpenAI 產生該文字的 embedding
 * 3) 使用 Pinecone 的 ANN 查詢 topK=1，取得最相似的句子
 * 4) 回傳查詢結果與相似度
 */
export const compareOneTextWithAllRelationshipInquiries = onRequest(
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
          top: { sentence: null, similarity: null },
          error: "Missing text",
        });
        return;
      }

      // (A) 先做一些基礎關鍵字或正則檢查 (可選)
      // 例如，你可以偵測「男朋友」、「單身」等關鍵詞
      const lowered = text.toLowerCase();
      let localCategory: "relationship_inquiry" | "none" = "none";
      if (lowered.includes("男朋友") || lowered.includes("單身")) {
        localCategory = "relationship_inquiry";
      }

      // (B) 呼叫 OpenAI 取得 embedding
      const apiKey = openAiApiKey.value();
      const embed = await getEmbeddingForText(text, apiKey);
      if (!embed) {
        res.status(500).json({
          input: text,
          top: { sentence: null, similarity: null },
          error: "Failed to get OpenAI embedding",
        });
        return;
      }

      // (C) 使用 Pinecone 查詢
      const index = getPineconeIndex();
      const queryResponse = await index.query({
        vector: embed,
        topK: 1,
        includeValues: false,
        includeMetadata: true,
      });

      // (D) 分析查詢結果
      if (!queryResponse.matches || queryResponse.matches.length === 0) {
        res.json({
          input: text,
          localCategory,
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
        localCategory, // 可能是 "relationship_inquiry" 或 "none"
        top: {
          sentence: topMatch.id,
          similarity: topMatch.score,
          original_text: topMatch.metadata?.original_text || null,
        },
        error: null,
      });
      return;
    } catch (err: unknown) {
      console.error("ANN error:", err);
      res.status(500).json({
        input: null,
        top: { sentence: null, similarity: null },
        error: err instanceof Error ? err.message : String(err),
      });
      return;
    }
  }
);
