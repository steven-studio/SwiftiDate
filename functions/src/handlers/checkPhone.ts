"use strict";
Object.defineProperty(exports, "__esModule", {value: true});
exports.checkPhoneHandler = void 0;

import * as functions from "firebase-functions"; // 或 v2: import { onRequest } from 'firebase-functions/v2/https'
import {initializeApp} from "firebase-admin/app";
import {getFirestore} from "firebase-admin/firestore";
import {parsePhoneNumberFromString} from "libphonenumber-js";

// Initialize Firebase Admin SDK
initializeApp();
const db = getFirestore();

/**
 * Check phone existence in Firestore.
 * @param {string} fullPhoneNumber
 * @return {Promise<boolean>}
 */
async function isPhoneRegistered(fullPhoneNumber: string) {
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
export const checkPhoneHandler = functions.https.onRequest(async (req, res) => {
  try {
    const {countryCode, phoneNumber} = req.body.data || {};

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
    const parsed = parsePhoneNumberFromString(fullPhone);

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
  } catch (error) {
    res.status(500).json({
      result: {
        isValid: false,
        exists: false,
        error: (error as Error).message,
      },
    });
  }
});
