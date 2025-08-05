/**
 * Import function triggers from their respective submodules:
 *
 * import { onRequest } from "firebase-functions/v2/https";
 * import { onDocumentWritten } from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

// 你已經有 chatCompletionGpt4o
export {chatCompletionGpt4o} from "./checkCompletionGpt4o";

// 一一 export 各個 phone 函式
export {checkPhoneHandler as checkPhone} from "./handlers/checkPhone";

// export checkUrl
export {checkUrl} from "./checkUrl";

// 匯出 createMatchToken
export {createMatchToken} from "./createMatchToken";

// 匯出 compareOneTextWithAllRedFlags
// export {compareOneTextWithAllRedFlags} from "./compareOneTextWithAllRedFlags";
export {copyUserData} from "./copyUserData";

// index.ts 新增：
export {loginHandler} from "./handlers/loginHandler";
