/**
 * Import function triggers from their respective submodules:
 *
 * import { onRequest } from "firebase-functions/v2/https";
 * import { onDocumentWritten } from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

import { onDocumentCreated } from "firebase-functions/v2/firestore";
import * as admin from "firebase-admin";

// 初始化 Firebase Admin
admin.initializeApp();
const db = admin.firestore();

// 省份 & 城市集合清單
const regionCollections: Record<string, string> = {
  hainan: "hainan_users",
  hongkong: "hongkong_users",
  macao: "macao_users",
  taiwan: "taiwan_users",
  japan: "japan_users",
  korea: "korea_users",
  // 新增深圳 & 珠海
  shenzhen: "shenzhen_users",
  zhuhai: "zhuhai_users",
};

// 🔹 **自動分類用戶到對應省份 / 城市**
export const assignUserToRegion = onDocumentCreated(
  "users/{userId}",
  async (event) => {
    const snap = event.data;
    if (!snap) {
      console.log("❌ 文檔不存在，跳過");
      return;
    }

    const userId = event.params.userId;
    const userData = snap.data();

    if (!userData || !userData.region) {
      console.log(`⚠️ 用戶 ${userId} 沒有設定有效的地區`);
      return;
    }

    const region = userData.region as string;
    if (!regionCollections[region]) {
      console.log(`⚠️ 未知地區 ${region}，跳過處理`);
      return;
    }

    const collectionName = regionCollections[region]; // 獲取對應的集合名稱
    const userRef = db.collection(collectionName).doc(userId);

    await userRef.set(userData);
    console.log(`✅ 用戶 ${userId} 已存入 ${collectionName}`);
  }
);

// 🔹 **查找用戶在哪個集合**
async function findUserCollection(userId: string): Promise<string | null> {
  // 依序檢查每個 region 集合，看看該 userId 是否存在
  for (const collection of Object.values(regionCollections)) {
    const userRef = await db.collection(collection).doc(userId).get();
    if (userRef.exists) {
      return collection;
    }
  }
  return null;
}

// 🔹 **用戶點讚時檢查是否匹配（支援跨集合）**
export const handleLike = onDocumentCreated(
  "{userCollection}/{userId}/likes/{likedUserId}",
  async (event) => {
    const snap = event.data; // Firestore v2：event.data
    if (!snap) {
      console.log("❌ 文檔不存在，跳過");
      return;
    }

    const userCollection = event.params.userCollection as string;
    const userId = event.params.userId as string;
    const likedUserId = event.params.likedUserId as string;

    // 檢查 userCollection 是否合法
    if (!Object.values(regionCollections).includes(userCollection)) {
      console.log(`⚠️ 無效的用戶集合 ${userCollection}，跳過處理`);
      return;
    }

    // 檢查 userId, likedUserId 格式是否符合預期
    const isValidId = (id: string) => /^[a-zA-Z0-9_-]{6,36}$/.test(id);
    if (!isValidId(userId) || !isValidId(likedUserId)) {
      console.log(`⚠️ 無效的用戶 ID (${userId}, ${likedUserId})，跳過處理`);
      return;
    }

    console.log(`🔍 ${userId}（來自 ${userCollection}） 喜歡了 ${likedUserId}`);

    // 找到 likedUserId 所在集合
    const likedUserCollection = await findUserCollection(likedUserId);
    if (!likedUserCollection) {
      console.log(`⚠️ 找不到 ${likedUserId} 的用戶集合`);
      return;
    }

    console.log(`✅ ${likedUserId} 屬於 ${likedUserCollection}`);

    // 檢查對方是否也已經喜歡了此 user
    const likedBackRef = db
      .collection(likedUserCollection)
      .doc(likedUserId)
      .collection("likes")
      .doc(userId);

    const likedBack = await likedBackRef.get();
    if (likedBack.exists) {
      console.log(`🎉 MATCH! ${userId} & ${likedUserId}`);

      await db.runTransaction(async (transaction) => {
        // 讀取最新的匹配狀態，確保匹配關係沒有被其他請求修改
        const userMatchRef = db
          .collection(userCollection)
          .doc(userId)
          .collection("matches")
          .doc(likedUserId);

        const likedUserMatchRef = db
          .collection(likedUserCollection)
          .doc(likedUserId)
          .collection("matches")
          .doc(userId);

        const userMatchDoc = await transaction.get(userMatchRef);
        const likedUserMatchDoc = await transaction.get(likedUserMatchRef);

        // 確保匹配記錄還未存在，避免多次寫入
        if (!userMatchDoc.exists && !likedUserMatchDoc.exists) {
          console.log(
            `🚀 Transaction: Creating Match between ${userId} and ${likedUserId}`
          );
          transaction.set(userMatchRef, {
            timestamp: admin.firestore.FieldValue.serverTimestamp(),
          });
          transaction.set(likedUserMatchRef, {
            timestamp: admin.firestore.FieldValue.serverTimestamp(),
          });
        } else {
          console.log(
            `⚠️ Transaction: Match already exists for ${userId} and ${likedUserId}`
          );
        }
      });

      console.log(`✅ Match Created: ${userId} ↔ ${likedUserId}`);
    } else {
      console.log(`🔹 ${likedUserId} 尚未點讚 ${userId}`);
    }
  }
);