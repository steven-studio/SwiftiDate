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
exports.loginHandler = exports.copyUserData = exports.createMatchToken = exports.checkUrl = exports.checkPhone = exports.chatCompletionGpt4o = void 0;
// 你已經有 chatCompletionGpt4o
var checkCompletionGpt4o_1 = require("./checkCompletionGpt4o");
Object.defineProperty(exports, "chatCompletionGpt4o", { enumerable: true, get: function () { return checkCompletionGpt4o_1.chatCompletionGpt4o; } });
// 一一 export 各個 phone 函式
var checkPhone_1 = require("./handlers/checkPhone");
Object.defineProperty(exports, "checkPhone", { enumerable: true, get: function () { return checkPhone_1.checkPhoneHandler; } });
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
// index.ts 新增：
var loginHandler_1 = require("./handlers/loginHandler");
Object.defineProperty(exports, "loginHandler", { enumerable: true, get: function () { return loginHandler_1.loginHandler; } });

var verifyLoginHttp_1 = require("./handlers/verifyLoginHttp")
Object.defineProperty(exports, "verifyLogin", {
  enumerable: true,
  get: () => verifyLoginHttp_1.verifyLogin,
})
//# sourceMappingURL=index.js.map


