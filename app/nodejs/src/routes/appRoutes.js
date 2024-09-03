const express = require('express');
const router = express.Router();

router.get('/', async (req, res) => {
    res.sendStatus(200);
    res.json(
        {
            "message": "ok"
        }
    );
});

router.get('/hello', async (req, res) => {
    res.sendStatus(200);
    res.json(
        {
            "message": "hello"
        }
    );
});

module.exports = router