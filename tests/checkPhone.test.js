// __tests__/checkTaiwanPhone.test.js
import { checkTaiwanPhone } from '../src/index'; // 你的函式
import firebaseFunctionsTest from 'firebase-functions-test';

const testEnv = firebaseFunctionsTest();

describe('checkPhone', () => {
  afterAll(() => {
    testEnv.cleanup();
  });

  it('should return exists=true if phone is found in Firestore', async () => {
    // 模擬 Firestore 資料或用測試專案 DB
    // 你可以在測試前先用 Admin SDK 寫一筆紀錄到 "taiwan_users"

    // 創建呼叫參數
    const data = { phone: '+886972516868' };
    const context = {}; // 如果需要 auth, appCheck, etc. 可以在這放

    // 直接呼叫你的函式
    const result = await checkPhone(data, context);
    expect(result.exists).toBe(true); // 假設我們已經建了資料
  });
});
