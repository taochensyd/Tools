const axios = require('axios');
const cheerio = require('cheerio');
const cluster = require('cluster');
const pm2 = require('pm2');

let printerInfo = {};

const fetchPrinterInfo = async () => {
    try {
        const response = await axios.get('http://192.168.0.40/general/information.html?kind=item');
        const $ = cheerio.load(response.data);
        const modelName = $('h1').text();
        const drumUnitLife = $('#drum_unit_life').text(); // Replace '#drum_unit_life' with the actual selector for the drum unit life element
        const tonerLife = $('#toner_life').text(); // Replace '#toner_life' with the actual selector for the toner life element
        printerInfo = { modelName, drumUnitLife, tonerLife };
    } catch (error) {
        console.error(`Failed to fetch printer info: ${error}`);
    }
};

// Fetch printer details immediately and then every 10 minutes only if it is the master cluster or master node or running on single instance
if (cluster.isMaster || (pm2 && pm2.process && pm2.process.pm_id === 0) || (!cluster.isWorker && !pm2)) {
    fetchPrinterInfo();
    setInterval(fetchPrinterInfo, 600000);
}

exports.getPrinterInfo = (req, res) => {
    res.json(printerInfo);
};
