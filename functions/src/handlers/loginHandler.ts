import * as functions from "firebase-functions";
import * as bcrypt from "bcrypt";
import cors from "cors"; // ✅ 修正引入方式
import {db} from "../firebase"; // 統一使用 firebase.ts 中的 db

const corsHandler = cors({origin: true});

export const loginHandler = functions.https.onRequest((req, res) => {
  corsHandler(req, res, async () => {
    if (req.method !== "POST") {
      res.status(405).json({success: false, message: "Method Not Allowed"});
      return;
    }

    const {phone, password} = req.body;

    if (!phone || !password) {
      res.status(400).json({success: false, message: "缺少必要參數"});
      return;
    }

    try {
      // ✅ 修改為透過 phoneNumber 欄位查詢
      const usersRef = db.collection("users");
      const query = usersRef.where("phoneNumber", "==", phone).limit(1);
      const snapshot = await query.get();

      if (snapshot.empty) {
        res.status(404).json({success: false, message: "用戶不存在"});
        return;
      }

      const userData = snapshot.docs[0].data();
      const passwordHash = userData?.passwordHash;

      if (!passwordHash) {
        res.status(500).json({success: false, message: "用戶密碼尚未設定"});
        return;
      }

      const isMatch = await bcrypt.compare(password, passwordHash);

      if (isMatch) {
        res.status(200).json({success: true});
      } else {
        res.status(401).json({success: false, message: "密碼錯誤"});
      }
    } catch (error) {
      const message = error instanceof Error ? error.message : "未知錯誤";
      res.status(500).json({success: false, message: "內部伺服器錯誤", error: message});
    }
  });
});
