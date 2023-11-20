const axios = require('axios');
const cheerio = require('cheerio');
const cluster = require('cluster');
const pm2 = require('pm2');

const printers = {
    25: 'HP-M880 Export',
    26: 'HP-M880 QA',
    27: 'HP-M880 OP',
    28: 'HP-M880 Local',
    29: 'HP-M880 Warehouse',
    30: 'HP-M880 L2 North',
};

let output = [];

const fetchPrinterDetails = async () => {
    let newOutput = [];
    for (let i in printers) {
        let printerDetails = {
            name: printers[i],
            ip: `192.168.0.${i}`
        };
        try {
            const response = await axios.get(`https://192.168.0.${i}/hp/device/InternalPages/Index?id=SuppliesStatus`, { httpsAgent: new (require('https').Agent)({ rejectUnauthorized: false }) });
            const $ = cheerio.load(response.data);
            printerDetails.tonerLevelBlack = $('#BlackCartridge1-Header_Level').text();
            printerDetails.tonerLevelCyan = $('#CyanCartridge1-Header_Level').text();
            printerDetails.tonerLevelMagenta = $('#MagentaCartridge1-Header_Level').text();
            printerDetails.tonerLevelYellow = $('#YellowCartridge1-Header_Level').text();
            printerDetails.drumLevelBlack = $('#BlackDrumCartridge1-Header_Level').text();
            printerDetails.drumLevelCyan = $('#CyanDrumCartridge1-Header_Level').text();
            printerDetails.drumLevelMagenta = $('#MagentaDrumCartridge1-Header_Level').text();
            printerDetails.drumLevelYellow = $('#YellowDrumCartridge1-Header_Level').text();
            printerDetails.fuserKitLevel = $('#Fuser1-Header_Level').text();
            printerDetails.documentFeederKitLevel = $('#DocumentFeederKit1-Header_Level').text();
        } catch (error) {
            printerDetails.error = error.toString();
        }
        newOutput.push(printerDetails);
    }
    output = newOutput;
};

// Fetch printer details immediately and then every 10 minutes only if it is the master cluster or master node or running on single instance
if (cluster.isMaster || (pm2 && pm2.process && pm2.process.pm_id === 0) || (!cluster.isWorker && !pm2)) {
    fetchPrinterDetails();
    setInterval(fetchPrinterDetails, 600000);
}


exports.getHomartPrinterTonerLevel = (req, res, next) => {
    try {
        res.json(output);
    } catch (error) {
        next(error);
    }
};
