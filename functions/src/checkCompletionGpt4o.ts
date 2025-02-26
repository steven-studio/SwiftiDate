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

// 假設你 payload 的結構是：
interface ChatCompletionRequest {
  messages: Array<{ role: string; content: string }>;
  model?: string;
}

const openAiKeySecret = defineSecret("OPENAI_API_KEY"); // 這裡對應上面那個 SECRET 名稱

// 註：onRequest 預設參數是 (req: functions.https.Request, res: functions.Response)
export const chatCompletionGpt4o = onRequest(
  {
    // 告訴 Cloud Functions 部署時，要注入 openAiKeySecret
    secrets: [openAiKeySecret],
  },
  async (req, res): Promise<void> => {
    // 透過 openAiKeySecret.value() 拿到實際金鑰
    const openaiKey = openAiKeySecret.value();

    if (!openaiKey) {
      // 不要 return res.status(...)，只呼叫完就 return;
      res.status(500).send({error: "OpenAI key not set in config"});
      return; // 確保函式結束
    }

    // 2. 解析客戶端傳過來的 body
    const body = req.body as ChatCompletionRequest;
    const {messages, model} = body;

    // (可加一層檢查)
    if (!messages || messages.length === 0) {
      res.status(400).send({error: "Missing messages array"});
      return;
    }

    try {
      // 3. 向 OpenAI 發送請求
      const response = await fetch("https://api.openai.com/v1/chat/completions", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "Authorization": `Bearer ${openaiKey}`,
        },
        body: JSON.stringify({
          model: model || "gpt-4o",
          messages: messages,
        }),
      });

      if (!response.ok) {
        const errorText = await response.text();
        res.status(500).send({
          error: "OpenAI API Error",
          detail: errorText,
        });
        return;
      }

      // 4. 正常解析成功
      const data = await response.json();
      res.status(200).send(data);
      return;
    } catch (err: unknown) {
      // err 是 unknown，需要先處理
      let msg = "Unknown error";
      if (err instanceof Error) {
        msg = err.message;
      } else {
        msg = String(err);
      }

      res.status(500).send({error: msg});
      return;
    }
  }
);

