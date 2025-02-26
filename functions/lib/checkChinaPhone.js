"use strict";
// checkChinaPhone.ts
Object.defineProperty(exports, "__esModule", { value: true });
exports.checkChinaPhone = void 0;
const https_1 = require("firebase-functions/v2/https");
// 這裡直接 import db, 不要再 initializeApp()
const adminConfig_1 = require("./adminConfig");
// Regex: +86 後面 11 位數字；你可依需求調整
const CHINA_PHONE_REGEX = /^\+86\d{11}$/;
/**
 * checkChinaPhone:
 * 1) 檢查 phone 格式是否符合 +86 後接 11 碼
 * 2) 若格式正確，查 Firestore 中 `china_users` 集合是否已有該 phone
 * 3) 回傳 { isValid, exists } 結果
 */
exports.checkChinaPhone = (0, https_1.onCall)(async (request) => {
    var _a, _b;
    // 1) 取得傳入參數
    const phone = ((_b = (_a = request.data) === null || _a === void 0 ? void 0 : _a.phone) === null || _b === void 0 ? void 0 : _b.toString().trim()) || "";
    // 2) 驗證格式
    const isValid = CHINA_PHONE_REGEX.test(phone);
    if (!isValid) {
        return { isValid: false, exists: false };
    }
    try {
        // 3) Firestore 查詢
        const snapshot = await adminConfig_1.db
            .collection("users") // 假設你存放在 `china_users`
            .where("phoneNumber", "==", phone)
            .limit(1)
            .get();
        const exists = !snapshot.empty; // 是否已有該號碼
        return { isValid: true, exists };
    }
    catch (error) {
        // 查詢或其他錯誤
        console.error("Firestore error:", error);
        return {
            error: "Firestore query failed",
            isValid: true, // 格式雖 valid，但查詢失敗
            exists: false,
        };
    }
});
//# sourceMappingURL=checkChinaPhone.js.map