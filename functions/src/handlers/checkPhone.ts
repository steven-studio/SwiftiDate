import * as functions from "firebase-functions";
import {initializeApp} from "firebase-admin/app";
import {getFirestore} from "firebase-admin/firestore";

// Initialize Firebase Admin SDK
initializeApp();
const db = getFirestore();

const phoneRegex: { [key: string]: string } = {
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
export function isValidPhone(countryCode: string, phoneNumber: string): boolean {
  const regex = phoneRegex[countryCode];
  if (!regex) throw new Error("Unsupported country code");
  return new RegExp(regex).test(phoneNumber);
}

/**
 * Check phone existence in Firestore.
 * @param {string} fullPhoneNumber
 * @return {Promise<boolean>}
 */
async function isPhoneRegistered(fullPhoneNumber: string): Promise<boolean> {
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
function normalizePhoneNumber(countryCode: string, phoneNumber: string): string {
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
export const checkPhoneHandler = functions.https.onRequest(async (req, res) => {
  try {
    const {countryCode, phoneNumber} = req.body.data;
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
  } catch (error) {
    const err = error as Error; // 明確轉型
    res.status(500).json({
      result: {
        isValid: false,
        exists: false,
        error: err.message,
      },
    });
  }
});
