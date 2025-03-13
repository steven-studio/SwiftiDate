const express = require('express');
const http = require('http');
const socketIo = require('socket.io');

const app = express();
const server = http.createServer(app);
const io = socketIo(server);

// 當有用戶連線時
io.on('connection', (socket) => {
    console.log('一個用戶已連線:', socket.id);

    // 接收來自用戶的訊息並廣播給其他用戶
    socket.on('signal', (data) => {
        console.log(`收到來自 ${socket.id} 的訊息:`, data);
        // 廣播訊息給除發送者以外的所有用戶
        socket.broadcast.emit('signal', data);
    });

    // 當用戶斷線時
    socket.on('disconnect', () => {
        console.log('用戶斷線:', socket.id);
    });
});

// 提供一個基本的首頁
app.get('/', (req, res) => {
    res.send('簡單的 Node.js 信令伺服器正在運行');
});

// 設定監聽的埠號
const PORT = process.env.PORT || 3000;
server.listen(PORT, () => {
    console.log(`伺服器正在 http://localhost:${PORT} 上運行`);
});
