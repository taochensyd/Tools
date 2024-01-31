const express = require('express');
const router = express.Router();
const dellServerOpenManageController = require('../controllers/dellServerOpenManageController');

// Get the status of a Homart printer
router.post('/homart/server/hardware/disk', dellServerOpenManageController.diskInfo);

module.exports = router;
