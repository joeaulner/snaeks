const path = require('path');
const express = require('express');
const app = express();
const server = require('http').createServer(app);
const WebSocket = require('ws');
const ws = require('express-ws')(app);


app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'index.html'));
});

app.use('/', express.static(path.join(__dirname, 'public')));

app.listen(5000, () => {
    console.log('The server is running: http://localhost:5000');
});



// WORLD DEFINITION


class Segment {
    constructor(x, y, d) {
        this.x = x;
        this.y = y;
    }
}

class SnakeSegment extends Segment {
    constructor(x, y, d) {
        super(x, y);
        this.d = d;
    }
}

class Player {
    constructor(name) {
        this.name = name;
        this.snake = [
            new SnakeSegment(0, 0, Direction.NORTH),
            new SnakeSegment(0, -1, Direction.NORTH),
            new SnakeSegment(0, -2, Direction.NORTH)
        ];
    }

    moveSnake() {
        const head = this.snake[0];
        var newHead;

        switch (head.d) {
            case Direction.NORTH:
                newHead = new SnakeSegment(head.x, head.y + 1, head.d);
                break;
            case Direction.EAST:
                newHead = new SnakeSegment(head.x + 1, head.y, head.d);
                break;
            case Direction.SOUTH:
                newHead = new SnakeSegment(head.x, head.y - 1, head.d);
                break;
            case Direction.WEST:
                newHead = new SnakeSegment(head.x - 1, head.y, head.d);
                break;
        }

        this.snake.pop();
        this.snake.unshift(newHead);
    }

    changeDirection(message) {
        const head = this.snake[0];
        const next = this.snake[1];
        const d = Direction[message];

        switch (d) {
            case Direction.NORTH:
                head.d = next.y === head.y + 1 ? head.d : d;
                break;
            case Direction.EAST:
                head.d = next.x === head.x + 1 ? head.d : d;
                break;
            case Direction.SOUTH:
                head.d = next.y === head.y - 1 ? head.d : d;
                break;
            case Direction.WEST:
                head.d = next.x === head.x - 1 ? head.d : d;
                break;
        }
    }
}

class Direction {
    constructor(name) {
        this.name = name;
    }
}
Direction.NORTH = new Direction('NORTH');
Direction.EAST = new Direction('EAST');
Direction.SOUTH = new Direction('SOUTH');
Direction.WEST = new Direction('WEST');

const players = new Map();



// SOCKET BEHAVIOR


app.ws('/game', (ws, req) => {
    players.set(ws, new Player(req.query.name));
    sendData(ws);
    
    ws.on('message', message => {
        if (Direction[message]) {
            const player = players.get(ws);
            player.changeDirection(message);
        }
    });

    ws.on('close', arg => {
        players.delete(ws);
    });
});



// WORLD UPDATES


// update snakes every 200 millseconds
setInterval(() => {
    ws.getWss().clients.forEach(client => players.get(client).moveSnake());
}, 200);

// send snake data every 50 milliseconds
setInterval(() => {
    ws.getWss().clients.forEach(sendData);
}, 50);

function sendData(client) {
    if (client.readyState === WebSocket.OPEN) {
        const snake = players.get(client).snake;
        client.send(JSON.stringify(snake));
    }
}
