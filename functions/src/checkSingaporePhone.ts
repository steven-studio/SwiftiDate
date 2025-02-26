// checkSingaporePhone.ts

import {onCall} from "firebase-functions/v2/https";
import {db} from "./adminConfig";

// 簡易範例 Regex：+65 後面 8 位數字
// 新加坡電話大多為 8 位，如 9xxxxxxx 或 8xxxxxxx，示例僅供參考
const SG_PHONE_REGEX = /^\+65\d{8}$/;

/**
 * checkSingaporePhone:
 * 1. 驗證是否為有效新加坡電話號碼 (isValid)
 * 2. 如果 isValid，查詢 `users` (或其他集合) 是否存在該 phone
 * 3. 回傳 { isValid, exists }
 */
export const checkSingaporePhone = onCall(async (request) => {
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
  const isValid = SG_PHONE_REGEX.test(phone);
  if (!isValid) {
    return {
      isValid: false,
      exists: false,
    };
  }

  // 3) 查詢 Firestore
  try {
    const snapshot = await db
      .collection("users") // 或 "singapore_users" 等你想要的集合
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
      isValid: true, // phone 格式 valid，但查詢失敗
      exists: false,
    };
  }
});
