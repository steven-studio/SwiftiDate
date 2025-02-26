"use strict";
/**
 * Import function triggers from their respective submodules:
 *
 * import { onRequest } from "firebase-functions/v2/https";
 * import { onDocumentWritten } from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */
Object.defineProperty(exports, "__esModule", { value: true });
exports.createMatchToken = void 0;
const https_1 = require("firebase-functions/v2/https");
const adminConfig_1 = require("./adminConfig");
/**
 * createMatchToken:
 *  - 只允許已登入 (context.auth) 的使用者呼叫
 *  - 產生一串隨機 token (12字元) 存到 Firestore
 *  - 回傳 tokenId 給呼叫端顯示
 */
exports.createMatchToken = (0, https_1.onCall)(async (request) => {
    var _a, _b;
    // 取得呼叫者 UID（相當於 v1 中的 context.auth.uid）
    const bUid = (_b = (_a = request.auth) === null || _a === void 0 ? void 0 : _a.token) === null || _b === void 0 ? void 0 : _b.uid;
    if (!bUid) {
        throw new https_1.HttpsError("unauthenticated", "User not logged in");
    }
    const tokenId = generateRandomString(12); // 生成12字元亂碼
    // 將 token 與 bUid 存到 Firestore (可自訂 collection 名稱)
    await adminConfig_1.admin.firestore()
        .collection("matchTokens")
        .doc(tokenId)
        .set({
        bUid,
        createdAt: adminConfig_1.admin.firestore.FieldValue.serverTimestamp(),
    });
    return { tokenId };
});
/**
 * 產生指定長度的隨機字串
 * @param {number} length 要生成的字串長度
 * @return {string} 亂數字串
 */
function generateRandomString(length) {
    const chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    let result = "";
    for (let i = 0; i < length; i++) {
        const randomIndex = Math.floor(Math.random() * chars.length);
        result += chars.charAt(randomIndex);
    }
    return result;
}
//# sourceMappingURL=createMatchToken.js.map