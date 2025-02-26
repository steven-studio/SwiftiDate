"use strict";
// checkNewZealandPhone.ts
Object.defineProperty(exports, "__esModule", { value: true });
exports.checkNewZealandPhone = void 0;
const https_1 = require("firebase-functions/v2/https");
const adminConfig_1 = require("./adminConfig");
// 簡易範例 Regex：+64 後面 8~9 位數字
// 實際紐西蘭電話格式可更複雜，請視需求自行調整
const NZ_PHONE_REGEX = /^\+64\d{8,9}$/;
/**
 * checkNewZealandPhone:
 * 1. 驗證是否為有效紐西蘭電話號碼 (isValid)
 * 2. 如果 isValid，查詢 `users` (或其他集合) 看是否已有該 phone
 * 3. 回傳 { isValid, exists }
 */
exports.checkNewZealandPhone = (0, https_1.onCall)(async (request) => {
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
    const isValid = NZ_PHONE_REGEX.test(phone);
    if (!isValid) {
        return {
            isValid: false,
            exists: false,
        };
    }
    // 3) 查詢 Firestore
    try {
        const snapshot = await adminConfig_1.db
            .collection("users") // 或 "newzealand_users" 等你想要的集合
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
            isValid: true, // 格式 valid，但查詢失敗
            exists: false,
        };
    }
});
//# sourceMappingURL=checkNewZealandPhone.js.map