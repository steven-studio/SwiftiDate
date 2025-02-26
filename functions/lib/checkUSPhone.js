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
exports.checkUSPhone = void 0;
const https_1 = require("firebase-functions/v2/https");
const adminConfig_1 = require("./adminConfig");
// 簡易 Regex：+1 後接 10 位數 (如: +12345678901)
const US_PHONE_REGEX = /^\+1\d{10}$/;
/**
 * checkUSPhone:
 * 1. 驗證是否為有效美國電話號碼 (isValid)
 * 2. 如果 isValid，查詢 `users` 集合中是否存在該 phone
 * 3. 回傳 { isValid, exists }
 */
exports.checkUSPhone = (0, https_1.onCall)(async (request) => {
    var _a, _b;
    // 1) 取得 phone 參數
    const phone = (_b = (_a = request.data) === null || _a === void 0 ? void 0 : _a.phone) === null || _b === void 0 ? void 0 : _b.toString().trim();
    if (!phone) {
        return {
            error: "Missing phone",
            isValid: false,
            exists: false,
        };
    }
    // 2) 驗證格式
    const isValid = US_PHONE_REGEX.test(phone);
    if (!isValid) {
        return {
            isValid: false,
            exists: false,
        };
    }
    // 3) 查詢 Firestore
    try {
        // 假設存在同一個 "users" 集合中
        const snapshot = await adminConfig_1.db
            .collection("users")
            .where("phoneNumber", "==", phone)
            .limit(1)
            .get();
        const exists = !snapshot.empty;
        return {
            isValid: true,
            exists,
        };
    }
    catch (err) {
        console.error("Firestore query error:", err);
        return {
            error: "Firestore query failed",
            isValid: true, // 格式仍 valid，但查詢失敗
            exists: false,
        };
    }
});
//# sourceMappingURL=checkUSPhone.js.map