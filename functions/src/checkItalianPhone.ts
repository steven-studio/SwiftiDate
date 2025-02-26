// checkItalianPhone.ts

import {onCall} from "firebase-functions/v2/https";
import {db} from "./adminConfig";

// 這裡示範 +39 後面 6~10 位數字 (依據義大利電話格式做簡化示例)
const ITALY_PHONE_REGEX = /^\+39\d{6,10}$/;

/**
 * checkItalianPhone:
 * 1. 驗證是否為有效義大利電話號碼 (isValid)
 * 2. 如果 isValid，查詢 Firestore 中是否存在該 phone
 * 3. 回傳 { isValid, exists }
 */
export const checkItalianPhone = onCall(async (request) => {
  // 1) 取得 phone
  const phone = request.data?.phone?.toString().trim();
  if (!phone) {
    return {
      error: "Missing phone",
      isValid: false,
      exists: false,
    };
  }

  // 2) 驗證格式
  const isValid = ITALY_PHONE_REGEX.test(phone);
  if (!isValid) {
    return {
      isValid: false,
      exists: false,
    };
  }

  // 3) 查詢 Firestore
  try {
    // 假設把所有電話存放在 "users" 集合，欄位為 "phoneNumber"
    const snapshot = await db
      .collection("users")
      .where("phoneNumber", "==", phone)
      .limit(1)
      .get();

    const exists = !snapshot.empty;
    return {
      isValid: true,
      exists,
    };
  } catch (err) {
    console.error("Firestore query error:", err);
    return {
      error: "Firestore query failed",
      isValid: true, // 格式是 valid，但查詢失敗
      exists: false,
    };
  }
});
