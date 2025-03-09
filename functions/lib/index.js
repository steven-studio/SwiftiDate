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
exports.copyUserData = exports.createMatchToken = exports.checkUrl = exports.checkUSPhone = exports.checkTaiwanPhone = exports.checkSingaporePhone = exports.checkNewZealandPhone = exports.checkMacaoPhone = exports.checkKoreaPhone = exports.checkJapanPhone = exports.checkItalianPhone = exports.checkHongKongPhone = exports.checkChinaPhone = exports.checkBritishPhone = exports.checkAustralianPhone = exports.chatCompletionGpt4o = void 0;
// 你已經有 chatCompletionGpt4o
var checkCompletionGpt4o_1 = require("./checkCompletionGpt4o");
Object.defineProperty(exports, "chatCompletionGpt4o", { enumerable: true, get: function () { return checkCompletionGpt4o_1.chatCompletionGpt4o; } });
// 一一 export 各個 phone 函式
var checkAustralianPhone_1 = require("./checkAustralianPhone");
Object.defineProperty(exports, "checkAustralianPhone", { enumerable: true, get: function () { return checkAustralianPhone_1.checkAustralianPhone; } });
var checkBritishPhone_1 = require("./checkBritishPhone");
Object.defineProperty(exports, "checkBritishPhone", { enumerable: true, get: function () { return checkBritishPhone_1.checkBritishPhone; } });
var checkChinaPhone_1 = require("./checkChinaPhone");
Object.defineProperty(exports, "checkChinaPhone", { enumerable: true, get: function () { return checkChinaPhone_1.checkChinaPhone; } });
var checkHongKongPhone_1 = require("./checkHongKongPhone");
Object.defineProperty(exports, "checkHongKongPhone", { enumerable: true, get: function () { return checkHongKongPhone_1.checkHongKongPhone; } });
var checkItalianPhone_1 = require("./checkItalianPhone");
Object.defineProperty(exports, "checkItalianPhone", { enumerable: true, get: function () { return checkItalianPhone_1.checkItalianPhone; } });
var checkJapanPhone_1 = require("./checkJapanPhone");
Object.defineProperty(exports, "checkJapanPhone", { enumerable: true, get: function () { return checkJapanPhone_1.checkJapanPhone; } });
var checkKoreaPhone_1 = require("./checkKoreaPhone");
Object.defineProperty(exports, "checkKoreaPhone", { enumerable: true, get: function () { return checkKoreaPhone_1.checkKoreaPhone; } });
var checkMacaoPhone_1 = require("./checkMacaoPhone");
Object.defineProperty(exports, "checkMacaoPhone", { enumerable: true, get: function () { return checkMacaoPhone_1.checkMacaoPhone; } });
var checkNewZealandPhone_1 = require("./checkNewZealandPhone");
Object.defineProperty(exports, "checkNewZealandPhone", { enumerable: true, get: function () { return checkNewZealandPhone_1.checkNewZealandPhone; } });
var checkSingaporePhone_1 = require("./checkSingaporePhone");
Object.defineProperty(exports, "checkSingaporePhone", { enumerable: true, get: function () { return checkSingaporePhone_1.checkSingaporePhone; } });
var checkTaiwanPhone_1 = require("./checkTaiwanPhone");
Object.defineProperty(exports, "checkTaiwanPhone", { enumerable: true, get: function () { return checkTaiwanPhone_1.checkTaiwanPhone; } });
var checkUSPhone_1 = require("./checkUSPhone");
Object.defineProperty(exports, "checkUSPhone", { enumerable: true, get: function () { return checkUSPhone_1.checkUSPhone; } });
// export checkUrl
var checkUrl_1 = require("./checkUrl");
Object.defineProperty(exports, "checkUrl", { enumerable: true, get: function () { return checkUrl_1.checkUrl; } });
// 匯出 createMatchToken
var createMatchToken_1 = require("./createMatchToken");
Object.defineProperty(exports, "createMatchToken", { enumerable: true, get: function () { return createMatchToken_1.createMatchToken; } });
// 匯出 compareOneTextWithAllRedFlags
// export {compareOneTextWithAllRedFlags} from "./compareOneTextWithAllRedFlags";
var copyUserData_1 = require("./copyUserData");
Object.defineProperty(exports, "copyUserData", { enumerable: true, get: function () { return copyUserData_1.copyUserData; } });
//# sourceMappingURL=index.js.map