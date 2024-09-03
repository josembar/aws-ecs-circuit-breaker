const express = require('express');
const router = express.Router();

router.get('/', async (req, res) => {
    res.json(
        {
            "message": "ok"
        }
    );
});

router.get('/hello', async (req, res) => {
    res.json(
        {
            "message": "hello"
        }
    );
});

module.exports = router