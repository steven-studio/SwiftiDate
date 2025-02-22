/**
 * Import function triggers from their respective submodules:
 *
 * import { onRequest } from "firebase-functions/v2/https";
 * import { onDocumentWritten } from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

import {onCall, HttpsError} from "firebase-functions/v2/https";
import * as admin from "firebase-admin";

// 若你的專案尚未 initializeApp，需要加上這行
// admin.initializeApp();

export const matchUsers = onCall(async (request) => {
  // `request` 取代了原本的 data, context
  // 使用者的 auth token: request.auth?.token
  const aUid = request.auth?.token?.uid;
  if (!aUid) {
    throw new HttpsError("unauthenticated", "User not logged in");
  }

  const tokenId = request.data.tokenId;
  if (!tokenId) {
    throw new HttpsError("invalid-argument", "No token provided");
  }

  // 從 matchTokens 拿到 bUid
  const tokenDoc = await admin.firestore().collection("matchTokens").doc(tokenId).get();
  if (!tokenDoc.exists) {
    throw new HttpsError("not-found", "Token not found or invalid");
  }
  
  const { bUid } = tokenDoc.data() || {};
  if (!bUid) {
    throw new HttpsError("not-found", "Token does not contain bUid");
  }

  // 檢查自己是否跟 bUid 一樣 (防止自己跟自己match)
  if (aUid === bUid) {
    throw new HttpsError("invalid-argument", "You cannot match with yourself");
  }

  // 從 userProfiles/{aUid} & {bUid} 撈兩邊的 gender
  const aSnap = await admin.firestore().collection("userProfiles").doc(aUid).get();
  const bSnap = await admin.firestore().collection("userProfiles").doc(bUid).get();
  if (!aSnap.exists || !bSnap.exists) {
    throw new HttpsError("not-found", "User profile not found");
  }
  const aData = aSnap.data() || {};
  const bData = bSnap.data() || {};

  const aGender = aData.gender; // 'male' or 'female'
  const bGender = bData.gender;
  // 你可以再判斷是不是 'male' or 'female'

  // 產生 matchId
  const matchId = [aUid, bUid].sort().join("_");

  // 先決定 maleUid / femaleUid
  let maleUid = aUid;
  let femaleUid = bUid;
  if (aGender !== "male") {
    // 表示 aUid 不是男 => bUid 是男 => swap
    maleUid = bUid;
    femaleUid = aUid;
  }

  // 在 matches/ 建立
  await admin.firestore().collection("matches").doc(matchId).set({
    matchId,
    maleUid,
    femaleUid,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  // 同步寫入 userProfiles/{aUid}/matches/{bUid}, userProfiles/{bUid}/matches/{aUid}
  await Promise.all([
    admin
      .firestore()
      .collection("userProfiles")
      .doc(aUid)
      .collection("matches")
      .doc(bUid)
      .set({
        matchedUid: bUid,
        matchId,
        matchedAt: admin.firestore.FieldValue.serverTimestamp(),
      }),
    admin
      .firestore()
      .collection("userProfiles")
      .doc(bUid)
      .collection("matches")
      .doc(aUid)
      .set({
        matchedUid: aUid,
        matchId,
        matchedAt: admin.firestore.FieldValue.serverTimestamp(),
      }),
    tokenDoc.ref.update({ used: true }),
  ]);

  return {
    success: true,
    aUid,
    bUid,
    matchId,
  };
});