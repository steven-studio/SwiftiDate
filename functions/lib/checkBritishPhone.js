"use strict";
// checkBritishPhone.ts
Object.defineProperty(exports, "__esModule", { value: true });
exports.checkBritishPhone = void 0;
const https_1 = require("firebase-functions/v2/https");
const adminConfig_1 = require("./adminConfig");
// 簡易範例 Regex：+44 後面 10 位數字 (通常英國手機格式更複雜，請依需求調整)
const UK_PHONE_REGEX = /^\+44\d{10}$/;
/**
 * checkBritishPhone:
 * 1. 驗證是否為有效英國電話號碼 (isValid)
 * 2. 如果 isValid，查詢 `users` 集合中是否存在該 phone
 * 3. 回傳 { isValid, exists }
 */
exports.checkBritishPhone = (0, https_1.onCall)(async (request) => {
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
    const isValid = UK_PHONE_REGEX.test(phone);
    if (!isValid) {
        return {
            isValid: false,
            exists: false,
        };
    }
    // 3) 查詢 Firestore
    try {
        const snapshot = await adminConfig_1.db
            .collection("users") // 或 "british_users" 依你需求
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
//# sourceMappingURL=checkBritishPhone.js.map