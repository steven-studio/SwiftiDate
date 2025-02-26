// adminConfig.ts

import * as admin from "firebase-admin";

// 確保只初始化一次
if (!admin.apps.length) {
  admin.initializeApp();
}

// 匯出 admin 與 db，其他檔案需要各種 Firestore/Auth 功能都可用此 admin
export {admin};
export const db = admin.firestore();
