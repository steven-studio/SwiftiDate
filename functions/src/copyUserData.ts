import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import { Request, Response } from "express";

// 只在尚未初始化時初始化 Firebase Admin
if (!admin.apps.length) {
  admin.initializeApp();
}

// 改寫 copyUserData 並指定 req 與 res 類型
export const copyUserData = functions.https.onRequest(async (req: Request, res: Response) => {
  // 從 query parameters 取得 oldUserID 與 newUserID
  const oldUserID = req.query.oldUserID;
  const newUserID = req.query.newUserID;

  if (!oldUserID || !newUserID) {
    res.status(400).send('請提供 oldUserID 與 newUserID');
    return;
  }

  const ref = admin.database().ref();
  const oldPath = `users/${oldUserID}`;
  const newPath = `users/${newUserID}`;

  try {
    // 讀取原始資料
    const snapshot = await ref.child(oldPath).once('value');
    if (!snapshot.exists()) {
      res.status(404).send('原位置資料不存在');
      return;
    }
    const data = snapshot.val();

    // 將資料寫入新位置
    await ref.child(newPath).set(data);
    res.send(`資料成功複製到 ${newPath}`);
  } catch (error) {
    res.status(500).send(`複製失敗：${(error as Error).message}`);
  }
});