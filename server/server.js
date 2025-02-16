// server.js
const express = require('express');
const bodyParser = require('body-parser');
const fs = require('fs');
const path = require('path'); // <-- 1) 引入 path

const app = express();
const PORT = process.env.PORT || 3000;

app.use(bodyParser.json());

// 1) 讓 Express 直接提供 index.html
//    假設 index.html 與 server.js 在同一層資料夾
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'index.html'));
});

// 定義一個 POST 端點來接收訊息
app.post('/saveMessage', (req, res) => {
  const { content, sender, time } = req.body;
  // 例如把收到的訊息寫進本地檔案
  const log = `Time: ${time}, SenderID: ${senderID}, SenderName: ${senderName}, Content: ${content}\n`;
  fs.appendFileSync('messages.log', log);
  
  console.log('Message saved to messages.log');
  res.status(200).send({ status: 'ok' });
});

app.listen(3000, () => {
  console.log('Server running on http://localhost:3000');
});
