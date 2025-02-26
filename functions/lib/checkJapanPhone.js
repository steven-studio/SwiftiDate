"use strict";
// checkJapanPhone.ts
Object.defineProperty(exports, "__esModule", { value: true });
exports.checkJapanPhone = void 0;
const https_1 = require("firebase-functions/v2/https");
const adminConfig_1 = require("./adminConfig");
// 簡易範例 Regex：+81 後面 9~10 位數字
// 實務中日本電話格式可能還要區分行動/市話等，可自行調整
const JAPAN_PHONE_REGEX = /^\+81\d{9,10}$/;
/**
 * checkJapanPhone:
 * 1. 驗證是否為有效日本電話號碼 (isValid)
 * 2. 如果 isValid，查詢 `users` (或其他集合) 中是否存在該 phone
 * 3. 回傳 { isValid, exists }
 */
exports.checkJapanPhone = (0, https_1.onCall)(async (request) => {
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
    const isValid = JAPAN_PHONE_REGEX.test(phone);
    if (!isValid) {
        return {
            isValid: false,
            exists: false,
        };
    }
    // 3) 查詢 Firestore
    try {
        // 假設所有電話都存放在 "users" 集合，以 "phoneNumber" 欄位存號碼
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
            isValid: true, // 格式是 valid，但查詢失敗
            exists: false,
        };
    }
});
//# sourceMappingURL=checkJapanPhone.js.map