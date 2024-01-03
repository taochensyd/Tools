const express = require('express');
const router = express.Router();
const homartiGuardController = require('../controllers/homartiGuardController');

router.post('/homart/iguard/Time', homartiGuardController.processData);
router.post('/homart/iguard/TimeData', homartiGuardController.timeData);

module.exports = router;
