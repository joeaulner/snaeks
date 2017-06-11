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

app.use('/', express.static(path.join(__dirname, 'public')));

app.use('/api', routes);

app.listen(5000, () => {
    console.log('The server is running: http://localhost:5000');
});

const players = new Map();

class Player {
    constructor(name) {
        this.name = name;
        this.snake = [
            { x: 15, y: 15, d: 'NORTH' },
            { x: 15, y: 14, d: 'NORTH' },
            { x: 15, y: 13, d: 'NORTH' }
        ];
    }
}

app.ws('/game', (ws, req) => {
    const player = new Player(req.query.name);
    players.set(ws, player);
    ws.send(JSON.stringify(player.snake));
    
    ws.on('message', message => {
        // this is where we'll handle directional input
        console.log(`Received message: ${message}`);
    });

    ws.on('close', arg => {
        players.delete(ws);
    });
});

setInterval(() => {
    ws.getWss().clients.forEach(client => {
        const snake = players.get(client).snake;
        snake.forEach(segment => segment.y++);

        if (client.readyState === WebSocket.OPEN) {
            client.send(JSON.stringify(snake));
        }
    });
}, 500);
