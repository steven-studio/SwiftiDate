"use strict";
/**
 * Import function triggers from their respective submodules:
 *
 * import { onRequest } from "firebase-functions/v2/https";
 * import { onDocumentWritten } from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */
Object.defineProperty(exports, "__esModule", { value: true });
exports.checkPhone = void 0;
const https_1 = require("firebase-functions/v2/https");
const app_1 = require("firebase-admin/app");
const firestore_1 = require("firebase-admin/firestore");
// 初始化 Firebase Admin
(0, app_1.initializeApp)();
const db = (0, firestore_1.getFirestore)();
// Cloud Functions (v2) onCall
exports.checkPhone = (0, https_1.onCall)(async (request) => {
    // 注意 v2 版的參數從 request 中取
    const phone = request.data.phone;
    // 查找 phone 的紀錄：
    const snapshot = await db
        .collection("users")
        .where("phoneNumber", "==", phone)
        .limit(1)
        .get();
    return { exists: !snapshot.empty };
});
//# sourceMappingURL=index.js.map