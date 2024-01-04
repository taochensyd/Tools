const express = require('express');
const router = express.Router();
const homartGetHypervVmDetailController = require('../controllers/homartGetHypervVmDetailController');

router.post('/homart/hyperv/vm', homartGetHypervVmDetailController.hypervVmDetail);

module.exports = router;
