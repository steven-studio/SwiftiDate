"use strict";
/**
 * Import function triggers from their respective submodules:
 *
 * import { onRequest } from "firebase-functions/v2/https";
 * import { onDocumentWritten } from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.checkUrl = void 0;
const https_1 = require("firebase-functions/v2/https");
const params_1 = require("firebase-functions/params");
const node_fetch_1 = __importDefault(require("node-fetch"));
// 先在 Firebase CLI 設定 secrets: firebase functions:secrets:set WEB_RISK_API_KEY
const webRiskApiKey = (0, params_1.defineSecret)("WEB_RISK_API_KEY");
exports.checkUrl = (0, https_1.onCall)({
    secrets: [webRiskApiKey], // 告知此函式會用到該 secret
    // 也可加更多參數，如 concurrency, region, timeout...
}, async (request) => {
    try {
        const urlToCheck = request.data.url;
        if (!urlToCheck) {
            throw new https_1.HttpsError("invalid-argument", "Missing 'url' in request.data");
        }
        // 從 secret 取出金鑰
        const key = webRiskApiKey.value();
        const threatTypes = ["MALWARE", "SOCIAL_ENGINEERING", "UNWANTED_SOFTWARE"];
        const threatTypesQuery = threatTypes.map((tt) => `threatTypes=${tt}`).join("&");
        const encodedUrl = encodeURIComponent(urlToCheck);
        const apiUrl = `https://webrisk.googleapis.com/v1/uris:search?key=${key}&${threatTypesQuery}&uri=${encodedUrl}`;
        const response = await (0, node_fetch_1.default)(apiUrl);
        if (!response.ok) {
            throw new https_1.HttpsError("unknown", "Web Risk call failed");
        }
        const json = (await response.json());
        const isMalicious = !!((json === null || json === void 0 ? void 0 : json.threats) && json.threats.length > 0);
        return {
            isMalicious,
            raw: json,
        };
    }
    catch (error) {
        if (error instanceof Error) {
            // 確定是 Error 物件，所以可以安全地讀取 error.message
            throw new https_1.HttpsError("unknown", error.message);
        }
        else {
            // 如果不是 Error，就給個預設訊息
            throw new https_1.HttpsError("unknown", "Error checking URL");
        }
    }
});
//# sourceMappingURL=checkUrl.js.map