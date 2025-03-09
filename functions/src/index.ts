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
export {checkAustralianPhone} from "./checkAustralianPhone";
export {checkBritishPhone} from "./checkBritishPhone";
export {checkChinaPhone} from "./checkChinaPhone";
export {checkHongKongPhone} from "./checkHongKongPhone";
export {checkItalianPhone} from "./checkItalianPhone";
export {checkJapanPhone} from "./checkJapanPhone";
export {checkKoreaPhone} from "./checkKoreaPhone";
export {checkMacaoPhone} from "./checkMacaoPhone";
export {checkNewZealandPhone} from "./checkNewZealandPhone";
export {checkSingaporePhone} from "./checkSingaporePhone";
export {checkTaiwanPhone} from "./checkTaiwanPhone";
export {checkUSPhone} from "./checkUSPhone";

// export checkUrl
export {checkUrl} from "./checkUrl";

// 匯出 createMatchToken
export {createMatchToken} from "./createMatchToken";

// 匯出 compareOneTextWithAllRedFlags
// export {compareOneTextWithAllRedFlags} from "./compareOneTextWithAllRedFlags";
export {copyUserData} from "./copyUserData";