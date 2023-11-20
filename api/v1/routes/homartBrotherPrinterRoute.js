const express = require('express');
const router = express.Router();
const homartBrotherPrinterController = require('../controllers/homartBrotherPrinterController');

// Get the status of a Homart printer
router.get('/homart/printer/tonerlevel/brother', homartBrotherPrinterController.getPrinterInfo);

module.exports = router;
