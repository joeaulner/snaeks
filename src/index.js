const express = require('express');
const app = express();
const path = require('path');
const routes = require('./api/routes');

app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'index.html'));
});

app.use('/', express.static(path.join(__dirname, 'out')));

app.use('/api', routes);

app.listen(5000, () => {
    console.log('The server is running: http://localhost:5000');
});
