const express = require('express');
const router = express.Router();
const homartRdsSessionController = require('../controllers/homartRdsSessionController');

router.get('/homart/server/session', homartRdsSessionController.getRdsSessionStatus);

module.exports = router;
