"use strict";

const functions = require("firebase-functions");
// Node 18+ already has global fetch, no need for "node-fetch"
// If you are on Node <18, uncomment the next line
// const fetch = require("node-fetch");

const { db, admin } = require("../firebase"); // ✅ reuse shared firebase.js

exports.verifyLogin = functions.https.onRequest(async (req, res) => {
  if (req.method !== "POST") {
    return res.status(405).json({ error: "Method Not Allowed" });
  }

  const { phoneNumber, password } = req.body;
  if (!phoneNumber || !password) {
    return res
      .status(400)
      .json({ error: "phoneNumber and password are required" });
  }

  try {
    // Step 1: lookup user profile in Firestore
    const snapshot = await db
      .collection("users")
      .where("phoneNumber", "==", phoneNumber)
      .limit(1)
      .get();

    if (snapshot.empty) {
      return res.status(401).json({ error: "User not found in Firestore" });
    }

    const userDoc = snapshot.docs[0].data();
    console.log("User data found:", userDoc);

    // Step 2: get email from Firebase Auth (via Admin SDK)
    let email;
    try {
      const userRecord = await admin.auth().getUserByPhoneNumber(phoneNumber);
      email = userRecord.email;
    } catch (e) {
      console.error("Auth lookup failed:", e);
      return res
        .status(401)
        .json({ error: "No Auth account for this phone number" });
    }

    if (!email) {
      return res
        .status(401)
        .json({ error: "No email associated with this phone number" });
    }

    // Step 3: verify password via Firebase Auth REST API
    const apiKey ="AIzaSyC_J7NUPwT-pwhNCOyHxDeRsldzfwvo0mE"

    const resp = await fetch(
      `https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=${apiKey}`,
      {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          email,
          password,
          returnSecureToken: true,
        }),
      }
    );

    const result = await resp.json();

    if (result.error) {
      console.error("Auth error:", result.error);
      return res.status(401).json({ error: result.error.message });
    }

    // ✅ Login success
    return res.json({
      success: true,
      uid: result.localId,
      idToken: result.idToken,
      email: result.email,
      refreshToken: result.refreshToken,
    });
  } catch (err) {
    console.error("Login failed:", err);
    return res.status(500).json({ error: "Login failed: " + err.message });
  }
});
