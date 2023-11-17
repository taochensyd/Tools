const express = require('express');
const router = express.Router();
const homartPrinterController = require('../controllers/homartPrinterController');

// Get the status of a Homart printer
router.get('/homart/printer/tonerlevel', homartPrinterController.getHomartPrinterTonerLevel);

module.exports = router;
