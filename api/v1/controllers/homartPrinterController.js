const axios = require('axios');
const cheerio = require('cheerio');
const https = require('https');

exports.getHomartPrinterTonerLevel = async (req, res) => {
    const printers = {
        25: 'HP-M880 Export',
        26: 'HP-M880 QA',
        27: 'HP-M880 OP',
        28: 'HP-M880 Local',
        29: 'HP-M880 Warehouse',
        30: 'HP-M880 L2 North',
    };

    const fetchPrinterDetails = async (id) => {
        let printerDetails = {
            name: printers[id],
            ip: `192.168.0.${id}`
        };

        try {
            const response = await axios.get(`https://192.168.0.${id}/hp/device/InternalPages/Index?id=SuppliesStatus`, {
                httpsAgent: new https.Agent({ rejectUnauthorized: false })
            });

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

        return printerDetails;
    };

    try {
        const printerDetailsPromises = Object.keys(printers).map(id => fetchPrinterDetails(id));
        const allPrinterDetails = await Promise.all(printerDetailsPromises);

        res.json(allPrinterDetails);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};
