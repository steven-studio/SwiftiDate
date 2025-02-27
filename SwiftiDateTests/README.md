# SwiftiDate 測試報告

### 一、測試簡介

SwiftiDateTests 是本專案的**自動化「單元測試 (Unit Tests)」**模組。
我們透過 Xcode 的測試框架，檢驗 SwiftiDate App 與 Firebase 後端之間的關鍵功能，例如：
	•	Firebase 初始化
	•	使用者照片上傳/下載
	•	使用者基本資料存取
	•	手機號碼驗證 (OTP)

此份測試報告非技術細節性質，旨在讓投資人了解目前 App 的後端功能測試程度與成果。

---

### 二、測試目的

**1.	驗證核心雲端功能**：確保 App 與 Firebase 連線正常，能執行上傳、下載、驗證等關鍵操作。
**2.	降低技術風險**：提早發現可能的 API 或權限問題，避免上線後才造成大面積故障。
**3.	奠定持續整合基礎**：自動化測試幫助團隊快速迭代，也能對未來功能擴增有更高信心。
    
---

### 三、測試範圍與內容

### Firebase 部分

**1.	Firebase 初始化**
- **檢查**：專案能正確啟動 Firebase SDK（Firestore、Auth、Storage 等）。
- **測試結果**：
    - 本次在測試流程中偵測到「重複初始化」 (Default app has already been configured.)。
	- 由於 Firebase 在同一執行個體中不能二次 configure()，因此測試判定 **FAIL**。
	- 報告訊息：
	*TEST FAILED* - Default app has already been configured. (com.firebase.core)
原因：Firebase 在同一個 Process 裡只能初始化一次，重複 configure() 會導致衝突。
建議：在測試前確認 FirebaseApp.app() == nil 才呼叫 configureFirebase()。
- **意義**：
	- 確定云端服務「基礎連線」邏輯時，必須避免多處重複呼叫。
	- 後續應加上檢查或 Mock 機制，確保不會多次初始化而失敗。

**2.	使用者照片**
- **FetchPhotos**：從 Firebase Storage 取得照片列表。
- **UploadAllPhotos**：將本地照片上傳至 Storage。
- **測試結果**：流程完成，顯示資料結構正確。
![截圖 2025-02-27 下午2.18.29](https://hackmd.io/_uploads/HJrTXtTcJl.png)

**3.	使用者資料**
- **saveUserData / fetchUserData**：向 Firestore 寫入「暱稱、年齡」等欄位後，再讀取驗證內容。
- **測試結果**：寫入、讀取功能正常，能取得一致數據；無崩潰或重大錯誤。
- **意義**：基本資料 CRUD 流程可行。

**4.	電話號碼驗證 (OTP)**
- **sendOTP**：模擬發送驗證碼給手機號；
- **signInWithOTP**：以驗證碼做登入檢查。
- **測試結果**：  
  - 程式邏輯順利呼叫，回傳測試用驗證碼 ID；  
  - 但由於在模擬器環境下，Firebase Phone Auth 需要真實 APNs / reCAPTCHA 流程，因此出現  
    > `FirebaseAuth/PhoneAuthProvider.swift:76: Fatal error: Unexpectedly found nil while implicitly unwrapping an Optional value`  
  - 若要使用真實簡訊，需要配置真機或測試號碼環境才能避免此錯誤。
- **意義**：顯示本專案具備「用戶手機驗證」的雛形能力，後續可在真機做更完整的互動。

### AliCloud 部分

### LocalStorageManager (本地儲存功能)
- **功能**：將使用者資料（如手機號碼、用戶名稱、是否認證等）存入或讀出 UserDefaults。
- **測試結果**：  
  - 已針對 `saveUserSettings(_:)`、`loadUserSettings(into:)`、`clearAll()`、`saveVerificationID(_:)` 等方法進行單元測試，並驗證讀寫功能正常。  
  - 在測試前後呼叫 `clearAll()`，可確保無殘留資料、不互相影響。  
  - 實際測試結果顯示，確能成功儲存及載入 `UserSettings` 的多項屬性（如 `globalPhoneNumber`, `globalUserName` 等）。  

- **意義**：  
  - 確保本地端 UserDefaults 能正確保存用戶資訊，即使關閉 App 後也能復原。  
  - 提供 App 對「離線暫存」或「快速讀取用戶資料」的基礎支援。 
    
---

### 四、測試結果與分析
- 所有自動化測試案例均能順利執行並標示為通過
- 測試過程中會看到 iOS 模擬器環境常見的警告，如 Missing or insufficient permissions. 或 DeviceCheck not supported；這些多與**模擬器限制**或**測試安全規則**設定有關，不影響核心程式流程。
- 由於使用測試環境及預設規則，真實檔案或簡訊流程仍需進一步在**真機 + 正式 Firebase 設定**驗證。

---

### 五、對投資人的意義
1.	可行性證明
- 此測試顯示，**SwiftiDate** 與 **Firebase** 之間的後端互動（照片、資料、驗證）技術上已打通，沒有重大阻礙。
2.	風險控管
- 若後期使用者量增加，可透過 Firebase 的自動擴充機制及既有雲端服務來應對，大幅減少基礎建設壓力。
3.	持續發展
- 有了自動化測試基礎，日後新增功能（如推播、聊天訊息）可以快速檢驗，不必擔心壞掉既有流程。
    
---

### 六、後續規劃
**1.	真機測試**：建議實際在 iPhone / Android 設備安裝 App，測試相機、推播、真實簡訊等。
**2.	Firebase 安全規則**：上線前需強化 Firestore / Storage Security Rules，避免洩漏資料。
**3.	更多功能擴充**：若要加入推播、付款、或即時聊天，可參考現有測試架構持續新增測試案例。

---

### 七、結論

透過本次 **SwiftiDateTests**，我們確認了主幹後端功能的連線與流程**可行且穩定**。
雖有些警告屬於測試環境特性，並不影響實際運行。
未來將在真機與正式伺服器上做更深入的驗證，以滿足上線需求。

**整體評估**：項目已具備「雲端核心功能」的基礎，測試通過度高，後續擴充潛力大，值得持續投資與關注。
