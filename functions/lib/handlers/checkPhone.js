// "use strict";
// var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
//     if (k2 === undefined) k2 = k;
//     var desc = Object.getOwnPropertyDescriptor(m, k);
//     if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
//       desc = { enumerable: true, get: function() { return m[k]; } };
//     }
//     Object.defineProperty(o, k2, desc);
// }) : (function(o, m, k, k2) {
//     if (k2 === undefined) k2 = k;
//     o[k2] = m[k];
// }));
// var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
//     Object.defineProperty(o, "default", { enumerable: true, value: v });
// }) : function(o, v) {
//     o["default"] = v;
// });
// var __importStar = (this && this.__importStar) || (function () {
//     var ownKeys = function(o) {
//         ownKeys = Object.getOwnPropertyNames || function (o) {
//             var ar = [];
//             for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
//             return ar;
//         };
//         return ownKeys(o);
//     };
//     return function (mod) {
//         if (mod && mod.__esModule) return mod;
//         var result = {};
//         if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
//         __setModuleDefault(result, mod);
//         return result;
//     };
// })();
// Object.defineProperty(exports, "__esModule", { value: true });
// exports.checkPhoneHandler = void 0;
// Object.defineProperty(exports, "__esModule", { value: true });
// exports.checkPhoneHandler = void 0;
// const functions = __importStar(require("firebase-functions")); // 或 v2: import { onRequest } from 'firebase-functions/v2/https'
// const app_1 = require("firebase-admin/app");
// const firestore_1 = require("firebase-admin/firestore");
// const libphonenumber_js_1 = require("libphonenumber-js");
// // Initialize Firebase Admin SDK
// (0, app_1.initializeApp)();
// const db = (0, firestore_1.getFirestore)();
// /**
//  * Check phone existence in Firestore.
//  * @param {string} fullPhoneNumber
//  * @return {Promise<boolean>}
//  */
// async function isPhoneRegistered(fullPhoneNumber) {
//     const snapshot = await db
//         .collection("users")
//         .where("phoneNumber", "==", fullPhoneNumber)
//         .limit(1)
//         .get();
//     return !snapshot.empty;
// }
// /**
//  * HTTP cloud function to validate and check phone number existence.
//  *
//  * @param {functions.Request} req - The HTTP request object.
//  * @param {functions.Response} res - The HTTP response object.
//  * @return {Promise<void>} - Promise resolves when response is sent.
//  */
// exports.checkPhoneHandler = functions.https.onRequest(async (req, res) => {
//     try {
//         const { countryCode, phoneNumber } = req.body.data || {};
//         if (!countryCode || !phoneNumber) {
//             res.status(400).json({
//                 result: {
//                     isValid: false,
//                     exists: false,
//                     error: "Missing country code or phone number",
//                 },
//             });
//             return;
//         }
//         const fullPhone = `${countryCode}${phoneNumber}`;
//         const parsed = (0, libphonenumber_js_1.parsePhoneNumberFromString)(fullPhone);
//         if (!parsed || !parsed.isValid()) {
//             res.json({
//                 result: {
//                     isValid: false,
//                     exists: false,
//                     error: "Invalid phone number format",
//                 },
//             });
//             return;
//         }
//         const exists = await isPhoneRegistered(parsed.number); // E.164 format
//         res.json({
//             result: {
//                 isValid: true,
//                 exists,
//             },
//         });
//     }
//     catch (error) {
//         res.status(500).json({
//             result: {
//                 isValid: false,
//                 exists: false,
//                 error: error.message,
//             },
//         });
//     }
// });
// //# sourceMappingURL=checkPhone.js.map


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
  // Original supported countries
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

  // Additional major countries
  "+33": "^[1-9][0-9]{8}$", // France
  "+49": "^[1-9][0-9]{10,11}$", // Germany
  "+34": "^[6-9][0-9]{8}$", // Spain
  "+31": "^[6][0-9]{8}$", // Netherlands
  "+32": "^[4][0-9]{8}$", // Belgium
  "+41": "^[7][0-9]{8}$", // Switzerland
  "+43": "^[6-9][0-9]{6,13}$", // Austria
  "+45": "^[2-9][0-9]{7}$", // Denmark
  "+46": "^[7][0-9]{8}$", // Sweden
  "+47": "^[4-9][0-9]{7}$", // Norway
  "+358": "^[4-5][0-9]{7,8}$", // Finland
  "+7": "^[9][0-9]{9}$", // Russia/Kazakhstan
  "+91": "^[6-9][0-9]{9}$", // India
  "+60": "^[1][0-9]{8,9}$", // Malaysia
  "+62": "^[8][0-9]{8,11}$", // Indonesia
  "+63": "^[9][0-9]{9}$", // Philippines
  "+66": "^[6-9][0-9]{8}$", // Thailand
  "+84": "^[3-9][0-9]{8}$", // Vietnam
  "+855": "^[1-9][0-9]{7,8}$", // Cambodia
  "+856": "^[2][0-9]{7}$", // Laos
  "+95": "^[9][0-9]{7,9}$", // Myanmar
  "+880": "^[1][0-9]{9}$", // Bangladesh
  "+94": "^[7][0-9]{8}$", // Sri Lanka
  "+977": "^[9][0-9]{9}$", // Nepal
  "+975": "^[1-9][0-9]{7}$", // Bhutan
  "+960": "^[7-9][0-9]{6}$", // Maldives
  "+92": "^[3][0-9]{9}$", // Pakistan
  "+93": "^[7][0-9]{8}$", // Afghanistan
  "+98": "^[9][0-9]{9}$", // Iran
  "+90": "^[5][0-9]{9}$", // Turkey
  "+972": "^[5][0-9]{8}$", // Israel
  "+971": "^[5][0-9]{8}$", // UAE
  "+966": "^[5][0-9]{8}$", // Saudi Arabia
  "+965": "^[5-9][0-9]{7}$", // Kuwait
  "+974": "^[3-7][0-9]{7}$", // Qatar
  "+973": "^[3-9][0-9]{7}$", // Bahrain
  "+968": "^[7-9][0-9]{7}$", // Oman
  "+967": "^[7][0-9]{8}$", // Yemen
  "+964": "^[7][0-9]{9}$", // Iraq
  "+962": "^[7][0-9]{8}$", // Jordan
  "+961": "^[3-9][0-9]{6,7}$", // Lebanon
  "+963": "^[9][0-9]{8}$", // Syria
  "+20": "^[1][0-9]{9}$", // Egypt
  "+27": "^[6-8][0-9]{8}$", // South Africa
  "+234": "^[7-9][0-9]{9}$", // Nigeria
  "+254": "^[7][0-9]{8}$", // Kenya
  "+255": "^[6-7][0-9]{8}$", // Tanzania
  "+256": "^[7][0-9]{8}$", // Uganda
  "+233": "^[2-5][0-9]{8}$", // Ghana
  "+225": "^[0-9][0-9]{7}$", // Ivory Coast
  "+221": "^[7][0-9]{8}$", // Senegal
  "+212": "^[6-7][0-9]{8}$", // Morocco
  "+213": "^[5-7][0-9]{8}$", // Algeria
  "+216": "^[2-9][0-9]{7}$", // Tunisia
  "+218": "^[9][0-9]{8}$", // Libya
  "+55": "^[1-9][0-9]{10}$", // Brazil
  "+54": "^[9][0-9]{9}$", // Argentina
  "+56": "^[9][0-9]{8}$", // Chile
  "+57": "^[3][0-9]{9}$", // Colombia
  "+58": "^[4][0-9]{9}$", // Venezuela
  "+51": "^[9][0-9]{8}$", // Peru
  "+593": "^[9][0-9]{8}$", // Ecuador
  "+595": "^[9][0-9]{8}$", // Paraguay
  "+598": "^[9][0-9]{7}$", // Uruguay
  "+591": "^[6-7][0-9]{7}$", // Bolivia
  "+52": "^[1][0-9]{10}$", // Mexico
  "+502": "^[4-5][0-9]{7}$", // Guatemala
  "+503": "^[6-7][0-9]{7}$", // El Salvador
  "+504": "^[3-9][0-9]{7}$", // Honduras
  "+505": "^[8][0-9]{7}$", // Nicaragua
  "+506": "^[6-8][0-9]{7}$", // Costa Rica
  "+507": "^[6][0-9]{7}$", // Panama
  "+509": "^[3-4][0-9]{7}$", // Haiti
  "+1876": "^[4-9][0-9]{6}$", // Jamaica
  "+1242": "^[4-5][0-9]{6}$", // Bahamas
  "+1246": "^[2-4][0-9]{6}$", // Barbados
  "+1284": "^[4][0-9]{6}$", // British Virgin Islands
  "+1345": "^[3-9][0-9]{6}$", // Cayman Islands
  "+1649": "^[2-4][0-9]{6}$", // Turks and Caicos
  "+1664": "^[4][0-9]{6}$", // Montserrat
  "+1721": "^[5][0-9]{6}$", // Sint Maarten
  "+1758": "^[4-7][0-9]{6}$", // Saint Lucia
  "+1767": "^[2-4][0-9]{6}$", // Dominica
  "+1784": "^[4-5][0-9]{6}$", // Saint Vincent and the Grenadines
  "+1787": "^[7-9][0-9]{6}$", // Puerto Rico
  "+1809": "^[2-9][0-9]{6}$", // Dominican Republic
  "+1829": "^[2-9][0-9]{6}$", // Dominican Republic
  "+1849": "^[2-9][0-9]{6}$", // Dominican Republic
  "+1868": "^[4-7][0-9]{6}$", // Trinidad and Tobago
  "+1869": "^[4-7][0-9]{6}$", // Saint Kitts and Nevis
  "+1473": "^[4][0-9]{6}$", // Grenada
  "+1441": "^[2-9][0-9]{6}$", // Bermuda
  "+1340": "^[3-7][0-9]{6}$", // US Virgin Islands
  "+1670": "^[2-9][0-9]{6}$", // Northern Mariana Islands
  "+1671": "^[4-6][0-9]{6}$", // Guam
  "+1684": "^[7][0-9]{6}$", // American Samoa
  "+685": "^[7][0-9]{6}$", // Samoa
  "+686": "^[3-9][0-9]{4}$", // Kiribati
  "+687": "^[7-9][0-9]{5}$", // New Caledonia
  "+688": "^[9][0-9]{4}$", // Tuvalu
  "+689": "^[8-9][0-9]{7}$", // French Polynesia
  "+690": "^[4][0-9]{3}$", // Tokelau
  "+691": "^[3-9][0-9]{6}$", // Micronesia
  "+692": "^[2-6][0-9]{6}$", // Marshall Islands
  "+850": "^[1][0-9]{9}$", // North Korea
  "+880": "^[1][0-9]{9}$", // Bangladesh
  "+375": "^[2-4][0-9]{8}$", // Belarus
  "+380": "^[5-9][0-9]{8}$", // Ukraine
  "+373": "^[6-7][0-9]{7}$", // Moldova
  "+372": "^[5][0-9]{7}$", // Estonia
  "+371": "^[2][0-9]{7}$", // Latvia
  "+370": "^[6][0-9]{7}$", // Lithuania
  "+48": "^[4-8][0-9]{8}$", // Poland
  "+420": "^[6-7][0-9]{8}$", // Czech Republic
  "+421": "^[9][0-9]{8}$", // Slovakia
  "+36": "^[2-7][0-9]{8}$", // Hungary
  "+40": "^[7][0-9]{8}$", // Romania
  "+359": "^[8-9][0-9]{8}$", // Bulgaria
  "+385": "^[9][0-9]{8}$", // Croatia
  "+386": "^[3-6][0-9]{7}$", // Slovenia
  "+387": "^[6][0-9]{7}$", // Bosnia and Herzegovina
  "+382": "^[6][0-9]{7}$", // Montenegro
  "+381": "^[6][0-9]{7,8}$", // Serbia
  "+383": "^[4-5][0-9]{7}$", // Kosovo
  "+389": "^[7][0-9]{7}$", // North Macedonia
  "+355": "^[6][0-9]{8}$", // Albania
  "+30": "^[6][0-9]{9}$", // Greece
  "+357": "^[9][0-9]{7}$", // Cyprus
  "+356": "^[7-9][0-9]{7}$", // Malta
  "+354": "^[6-8][0-9]{6}$", // Iceland
  "+353": "^[8][0-9]{8}$", // Ireland
  "+351": "^[9][0-9]{8}$", // Portugal
  "+376": "^[3-6][0-9]{5}$", // Andorra
  "+377": "^[6][0-9]{7}$", // Monaco
  "+378": "^[6][0-9]{9}$", // San Marino
  "+379": "^[0-9]{8}$", // Vatican City
  "+423": "^[6-7][0-9]{6}$", // Liechtenstein
  "+352": "^[6][0-9]{8}$", // Luxembourg
}
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


