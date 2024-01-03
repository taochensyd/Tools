const express = require('express');
const router = express.Router();
const replicationHealthController = require('../controllers/replicationHealthController');

router.post('/hyperv/replicationhealth', replicationHealthController.postReplicationHealth);

module.exports = router;
