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
exports.checkPhoneHandler = void 0;
exports.isValidPhone = isValidPhone;
const functions = __importStar(require("firebase-functions"));
const app_1 = require("firebase-admin/app");
const firestore_1 = require("firebase-admin/firestore");
// Initialize Firebase Admin SDK
(0, app_1.initializeApp)();
const db = (0, firestore_1.getFirestore)();
const phoneRegex = {
    "+886": "^9[0-9]{8}$",
    "+86": "^[1][3-9][0-9]{9}$",
    "+852": "^[0-9]{8}$",
    "+853": "^[0-9]{8}$",
    "+1": "^[2-9][0-9]{9}$",
    "+65": "^[689][0-9]{7}$",
    "+81": "^[789]0[0-9]{8}$",
    "+61": "^[45][0-9]{8}$",
    "+44": "^[1-9][0-9]{9}$",
    "+39": "^[0-9]{8,10}$",
    "+64": "^[278][0-9]{7,9}$",
    "+82": "^01[016789][0-9]{7,8}$",
};
/**
 * 單一驗證函數（統一處理）。
 *
 * @param {string} countryCode 國際電話國碼 (例如 "+886")
 * @param {string} phoneNumber 不包含國碼的電話號碼字串 (例如 "0912345678")
 * @return {boolean} 若電話號碼符合指定國家格式則回傳 true，否則
 */
function isValidPhone(countryCode, phoneNumber) {
    const regex = phoneRegex[countryCode];
    if (!regex)
        throw new Error("Unsupported country code");
    return new RegExp(regex).test(phoneNumber);
}
/**
 * Check phone existence in Firestore.
 * @param {string} fullPhoneNumber
 * @return {Promise<boolean>}
 */
async function isPhoneRegistered(fullPhoneNumber) {
    const snapshot = await db
        .collection("users")
        .where("phoneNumber", "==", fullPhoneNumber)
        .limit(1)
        .get();
    return !snapshot.empty;
}
/**
 * Normalize phone number format by removing leading zero if present.
 *
 * @param {string} countryCode - The country calling code (e.g., "+886").
 * @param {string} phoneNumber - The phone number string.
 * @return {string} - Normalized phone number.
 */
function normalizePhoneNumber(countryCode, phoneNumber) {
    if (countryCode === "+886") {
        // 如果電話以 "0" 開頭就移除
        return phoneNumber.startsWith("0") ? phoneNumber.substring(1) : phoneNumber;
    }
    return phoneNumber;
}
/**
 * HTTP cloud function to validate and check phone number existence.
 *
 * @param {functions.Request} req - The HTTP request object.
 * @param {functions.Response} res - The HTTP response object.
 * @return {Promise<void>} - Promise resolves when response is sent.
 */
exports.checkPhoneHandler = functions.https.onRequest(async (req, res) => {
    try {
        const { countryCode, phoneNumber } = req.body.data;
        const normalizedPhone = normalizePhoneNumber(countryCode, phoneNumber);
        const fullPhoneNumber = `${countryCode}${normalizedPhone}`;
        const isValid = isValidPhone(countryCode, normalizedPhone);
        if (!isValid) {
            res.json({
                result: {
                    isValid: false,
                    exists: false,
                    error: "Invalid phone number format",
                },
            });
            return;
        }
        const exists = await isPhoneRegistered(fullPhoneNumber);
        res.json({
            result: {
                isValid: true,
                exists,
            },
        });
    }
    catch (error) {
        const err = error; // 明確轉型
        res.status(500).json({
            result: {
                isValid: false,
                exists: false,
                error: err.message,
            },
        });
    }
});
//# sourceMappingURL=checkPhone.js.map