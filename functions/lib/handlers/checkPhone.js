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
Object.defineProperty(exports, "__esModule", { value: true });
exports.checkPhoneHandler = void 0;
const functions = __importStar(require("firebase-functions")); // 或 v2: import { onRequest } from 'firebase-functions/v2/https'
const app_1 = require("firebase-admin/app");
const firestore_1 = require("firebase-admin/firestore");
const libphonenumber_js_1 = require("libphonenumber-js");
// Initialize Firebase Admin SDK
(0, app_1.initializeApp)();
const db = (0, firestore_1.getFirestore)();
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
 * HTTP cloud function to validate and check phone number existence.
 *
 * @param {functions.Request} req - The HTTP request object.
 * @param {functions.Response} res - The HTTP response object.
 * @return {Promise<void>} - Promise resolves when response is sent.
 */
exports.checkPhoneHandler = functions.https.onRequest(async (req, res) => {
    try {
        const { countryCode, phoneNumber } = req.body.data || {};
        if (!countryCode || !phoneNumber) {
            res.status(400).json({
                result: {
                    isValid: false,
                    exists: false,
                    error: "Missing country code or phone number",
                },
            });
            return;
        }
        const fullPhone = `${countryCode}${phoneNumber}`;
        const parsed = (0, libphonenumber_js_1.parsePhoneNumberFromString)(fullPhone);
        if (!parsed || !parsed.isValid()) {
            res.json({
                result: {
                    isValid: false,
                    exists: false,
                    error: "Invalid phone number format",
                },
            });
            return;
        }
        const exists = await isPhoneRegistered(parsed.number); // E.164 format
        res.json({
            result: {
                isValid: true,
                exists,
            },
        });
    }
    catch (error) {
        res.status(500).json({
            result: {
                isValid: false,
                exists: false,
                error: error.message,
            },
        });
    }
});
//# sourceMappingURL=checkPhone.js.map