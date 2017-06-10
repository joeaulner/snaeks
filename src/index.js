const path = require('path');
const express = require('express');
const app = express();
const server = require('http').createServer(app);
const WebSocket = require('ws');
const ws = require('express-ws')(app);
const routes = require('./api/routes');

app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'index.html'));
});

app.use('/', express.static(path.join(__dirname, 'out')));

app.use('/api', routes);

app.listen(5000, () => {
    console.log('The server is running: http://localhost:5000');
});

app.ws('/hello', (ws, req) => {
    console.log('A client connected! :D');

    var snake = [
        { x: 15, y: 15, d: 'NORTH' },
        { x: 15, y: 14, d: 'NORTH' },
        { x: 15, y: 13, d: 'NORTH' }
    ];
    broadcast(JSON.stringify(snake));

    ws.on('message', message => {
        console.log(`Received message: ${message}`);
    });

    ws.on('close', arg => {
        console.log(`A client disconnected :(`);
    });
});

function broadcast(message) {
    ws.getWss().clients.forEach((client) => {
        if (client.readyState === WebSocket.OPEN) {
            client.send(message);
        }
    });
}
