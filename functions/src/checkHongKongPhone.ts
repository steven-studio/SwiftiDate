/**
 * Import function triggers from their respective submodules:
 *
 * import { onRequest } from "firebase-functions/v2/https";
 * import { onDocumentWritten } from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

import {onCall} from "firebase-functions/v2/https";
import {db} from "./adminConfig";

// 簡易範例 Regex：+852 後接 8 位數
// 實務上可依實際香港電話格式進一步調整
const HK_PHONE_REGEX = /^\+852\d{8}$/;

/**
 * checkHongKongPhone:
 * 1. 驗證是否為有效香港電話號碼 (isValid)
 * 2. 如果 isValid，查詢 `users` 集合中是否存在該 phone
 * 3. 回傳 { isValid, exists }
 */
export const checkHongKongPhone = onCall(async (request) => {
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
  const isValid = HK_PHONE_REGEX.test(phone);
  if (!isValid) {
    return {
      isValid: false,
      exists: false,
    };
  }

  // 3) 查詢 Firestore
  try {
    const snapshot = await db
      .collection("users") // 或 "hongkong_users" 看你需求
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
      isValid: true, // 格式仍 valid，但查詢失敗
      exists: false,
    };
  }
});
