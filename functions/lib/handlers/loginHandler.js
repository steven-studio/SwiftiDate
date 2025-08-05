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
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.loginHandler = void 0;
const functions = __importStar(require("firebase-functions"));
const bcrypt = __importStar(require("bcrypt"));
const cors_1 = __importDefault(require("cors")); // ✅ 修正引入方式
const firebase_1 = require("../firebase"); // 統一使用 firebase.ts 中的 db
const corsHandler = (0, cors_1.default)({ origin: true });
exports.loginHandler = functions.https.onRequest((req, res) => {
    corsHandler(req, res, async () => {
        if (req.method !== "POST") {
            res.status(405).json({ success: false, message: "Method Not Allowed" });
            return;
        }
        const { phone, password } = req.body;
        if (!phone || !password) {
            res.status(400).json({ success: false, message: "缺少必要參數" });
            return;
        }
        try {
            // ✅ 修改為透過 phoneNumber 欄位查詢
            const usersRef = firebase_1.db.collection("users");
            const query = usersRef.where("phoneNumber", "==", phone).limit(1);
            const snapshot = await query.get();
            if (snapshot.empty) {
                res.status(404).json({ success: false, message: "用戶不存在" });
                return;
            }
            const userData = snapshot.docs[0].data();
            const passwordHash = userData === null || userData === void 0 ? void 0 : userData.passwordHash;
            if (!passwordHash) {
                res.status(500).json({ success: false, message: "用戶密碼尚未設定" });
                return;
            }
            const isMatch = await bcrypt.compare(password, passwordHash);
            if (isMatch) {
                res.status(200).json({ success: true });
            }
            else {
                res.status(401).json({ success: false, message: "密碼錯誤" });
            }
        }
        catch (error) {
            const message = error instanceof Error ? error.message : "未知錯誤";
            res.status(500).json({ success: false, message: "內部伺服器錯誤", error: message });
        }
    });
});
//# sourceMappingURL=loginHandler.js.map