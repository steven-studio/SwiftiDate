"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.copyUserData = void 0;
const functions = __importStar(require("firebase-functions"));
const admin = __importStar(require("firebase-admin"));
// 只在尚未初始化時初始化 Firebase Admin
if (!admin.apps.length) {
    admin.initializeApp();
}
// 改寫 copyUserData 並指定 req 與 res 類型
exports.copyUserData = functions.https.onRequest(async (req, res) => {
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
    }
    catch (error) {
        res.status(500).send(`複製失敗：${error.message}`);
    }
});
//# sourceMappingURL=copyUserData.js.map