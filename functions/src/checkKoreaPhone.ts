// checkKoreaPhone.ts

import {onCall} from "firebase-functions/v2/https";
import {db} from "./adminConfig";

// 簡易範例 Regex：+82 後面 9~10 位數字
// 實務上韓國電話格式可再依需要調整
const KOREA_PHONE_REGEX = /^\+82\d{9,10}$/;

/**
 * checkKoreaPhone:
 * 1. 驗證是否為有效韓國電話號碼 (isValid)
 * 2. 如果 isValid，查詢 `users` 集合中是否存在該 phone
 * 3. 回傳 { isValid, exists }
 */
export const checkKoreaPhone = onCall(async (request) => {
  // 1) 取得 phone 參數
  const phone = request.data?.phone?.toString().trim();
  if (!phone) {
    return {
      error: "Missing phone",
      isValid: false,
      exists: false,
    };
  }

  // 2) 驗證格式
  const isValid = KOREA_PHONE_REGEX.test(phone);
  if (!isValid) {
    return {
      isValid: false,
      exists: false,
    };
  }

  // 3) 查詢 Firestore
  try {
    // 假設所有電話都存放在 "users" 集合，以 "phoneNumber" 欄位存號碼
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
      isValid: true, // 格式 valid，但查詢失敗
      exists: false,
    };
  }
});
