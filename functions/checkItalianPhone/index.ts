/**
 * Import function triggers from their respective submodules:
 *
 * import { onRequest } from "firebase-functions/v2/https";
 * import { onDocumentWritten } from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

import {onCall} from "firebase-functions/v2/https";
import {initializeApp} from "firebase-admin/app";
import {getFirestore} from "firebase-admin/firestore";

// 初始化 Firebase Admin
initializeApp();
const db = getFirestore();

// Cloud Functions (v2) onCall
export const checkItalianPhone = onCall(async (request) => {
  // 注意 v2 版的參數從 request 中取
  const phone = request.data.phone;

  // 查找 phone 的紀錄：
  const snapshot = await db
    .collection("italian_users")
    .where("phoneNumber", "==", phone)
    .limit(1)
    .get();

  return {exists: !snapshot.empty};
});
