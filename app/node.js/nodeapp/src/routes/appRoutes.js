const express = require('express');
const router = express.Router();

router.get('/', async (req, res) => {
    res.status(200).json(
        {
            "message": "ok"
        }
    );
});

router.get('/hello', async (req, res) => {
    res.status(200).json(
        {
            "message": "hello"
        }
    );
});

module.exports = router