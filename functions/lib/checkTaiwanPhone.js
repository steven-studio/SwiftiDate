"use strict";
// checkTaiwanPhone.ts
Object.defineProperty(exports, "__esModule", { value: true });
exports.checkTaiwanPhone = void 0;
const https_1 = require("firebase-functions/v2/https");
// 這裡直接 import db, 不要再 initializeApp()
const adminConfig_1 = require("./adminConfig");
// 簡易範例 Regex：+886 後面接 9 碼 (如: +886912345678)
// 實務上台灣市話或手機格式更複雜，需要的話可自行再做進階判斷
const TAIWAN_PHONE_REGEX = /^\+886\d{9}$/;
/**
 * checkTaiwanPhone:
 * 1. 驗證是否為有效台灣電話號碼 (isValid)
 * 2. 如果 isValid，查詢 `taiwan_users` 集合中是否存在該 phone
 * 3. 回傳 { isValid, exists }
 */
exports.checkTaiwanPhone = (0, https_1.onCall)(async (request) => {
    var _a, _b;
    // 從 request.data.phone 取得號碼
    const phone = (_b = (_a = request.data) === null || _a === void 0 ? void 0 : _a.phone) === null || _b === void 0 ? void 0 : _b.toString().trim();
    if (!phone) {
        // 如果沒有傳 phone，就直接回傳錯誤訊息
        return {
            error: "Missing phone",
            isValid: false,
            exists: false,
        };
    }
    // 1) 檢查格式是否符合台灣電話（簡化示範）
    const isValid = TAIWAN_PHONE_REGEX.test(phone);
    if (!isValid) {
        // 如果不符合正則，直接回傳
        return {
            isValid: false,
            exists: false,
        };
    }
    // 2) 如果格式正確，再去 Firestore 查詢
    try {
        // 假設存放在 `taiwan_users` 集合
        const snapshot = await adminConfig_1.db
            .collection("users")
            .where("phoneNumber", "==", phone)
            .limit(1)
            .get();
        // 判斷是否有紀錄
        const exists = !snapshot.empty;
        // 3) 回傳結果
        return {
            isValid: true,
            exists,
        };
    }
    catch (err) {
        // 如果查詢過程中有錯誤，可以回傳錯誤訊息
        console.error("Firestore query error:", err);
        return {
            error: "Firestore query failed",
            isValid: true, // phone 格式是 valid，但查詢失敗
            exists: false,
        };
    }
});
//# sourceMappingURL=checkTaiwanPhone.js.map