/**
 * Import function triggers from their respective submodules:
 *
 * import { onRequest } from "firebase-functions/v2/https";
 * import { onDocumentWritten } from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

import {onCall, HttpsError} from "firebase-functions/v2/https";
import {defineSecret} from "firebase-functions/params";
import fetch from "node-fetch";

// 先在 Firebase CLI 設定 secrets: firebase functions:secrets:set WEB_RISK_API_KEY
const webRiskApiKey = defineSecret("WEB_RISK_API_KEY");

export const checkUrl = onCall(
  {
    secrets: [webRiskApiKey], // 告知此函式會用到該 secret
    // 也可加更多參數，如 concurrency, region, timeout...
  },
  async (request) => {
    try {
      const urlToCheck: string = request.data.url;
      if (!urlToCheck) {
        throw new HttpsError("invalid-argument", "Missing 'url' in request.data");
      }

      // 從 secret 取出金鑰
      const key = webRiskApiKey.value();
      const threatTypes = ["MALWARE", "SOCIAL_ENGINEERING", "UNWANTED_SOFTWARE"];
      const threatTypesQuery = threatTypes.map((tt) => `threatTypes=${tt}`).join("&");

      const encodedUrl = encodeURIComponent(urlToCheck);
      const apiUrl = `https://webrisk.googleapis.com/v1/uris:search?key=${key}&${threatTypesQuery}&uri=${encodedUrl}`;

      const response = await fetch(apiUrl);
      if (!response.ok) {
        throw new HttpsError("unknown", "Web Risk call failed");
      }

      interface UrlCheckResponse {
        threats?: any[];
      }

      const json = (await response.json()) as UrlCheckResponse;
      const isMalicious = !!(json?.threats && json.threats.length > 0);

      return {
        isMalicious,
        raw: json,
      };
    } catch (error: unknown) {
      if (error instanceof Error) {
        // 確定是 Error 物件，所以可以安全地讀取 error.message
        throw new HttpsError("unknown", error.message);
      } else {
        // 如果不是 Error，就給個預設訊息
        throw new HttpsError("unknown", "Error checking URL");
      }
    }
  }
);

