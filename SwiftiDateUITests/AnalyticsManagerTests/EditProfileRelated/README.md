## 測試結果

我們針對 **AboutMeSection** 進行了單元測試，主要檢查以下幾點：

- 當用戶在「關於我」文字區域輸入文字時，能正確觸發 Analytics 事件，並上報文字長度。
- 透過依賴注入方式使用 MockAnalyticsManager，模擬 Analytics 行為，確保事件追蹤邏輯無誤。

所有測試均已成功通過，確保我們的 AboutMeSection 在用戶互動時能夠穩定且正確地上報分析數據。

### 測試通過截圖：
![AboutMeSection 測試通過](./AboutMeSectionTestResult.png)

---

接著，我們針對 **BasicInfoView** 進行了 UI 互動測試，主要檢查以下幾點：

- 當用戶點擊「來自」這一基本資料列時，能正確觸發 Analytics 事件，並上報 "tap_edit_hometown" 事件。
- 點擊後能正確設置顯示 hometown 輸入頁面的標誌，確保用戶能夠進行資料更新。

所有測試均已成功通過，確保我們的 BasicInfoView 在用戶互動時能夠正確響應並記錄使用者行為。

### 測試通過截圖：
![BasicInfoView 測試通過](./BasicInfoViewTestResult.png)

---

### DegreePicker 測試結果
我們針對  進行了 UI 互動測試，主要檢查以下幾點：
- 當用戶點擊「學士」按鈕時，綁定值能正確更新為「學士」。
- 當用戶點擊「取消」按鈕時，綁定值能被清空（變為 nil）。
所有測試均已成功通過，確保我們的 DegreePicker 在用戶操作時能夠正確更新並響應。

### 測試通過截圖：
![DegreePicker 測試通過](./DegreePickerTestResult.png)
