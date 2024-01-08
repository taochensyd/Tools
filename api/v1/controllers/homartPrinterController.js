const axios = require('axios');
const cheerio = require('cheerio');
const cluster = require('cluster');
const pm2 = require('pm2');
const nodemailer = require('nodemailer');

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
            printerDetails.transferKitLevel = $('#ImageTransferBelt1-Header_Level').text();
            printerDetails.documentFeederKitLevel = $('#DocumentFeederKit1-Header_Level').text();
        } catch (error) {
            printerDetails.error = error.toString();
        }
        newOutput.push(printerDetails);
    }
    output = newOutput;
};

const sendEmail = async (output) => {
    let transporter = nodemailer.createTransport({
        host: 'homart-com-au.mail.protection.outlook.com',
        port: 25, // Standard SMTP port for unauthenticated email sending
        secure: false, // true for 465, false for other ports
        tls: {
            rejectUnauthorized: false
        }
    });

    let htmlContent = '<style>table {border-collapse: collapse;} th, td {border: 1px solid black; padding: 5px;}</style><table><tr><th>Name</th><th>IP</th><th>Toner Level Black</th><th>Toner Level Cyan</th><th>Toner Level Magenta</th><th>Toner Level Yellow</th><th>Drum Level Black</th><th>Drum Level Cyan</th><th>Drum Level Magenta</th><th>Drum Level Yellow</th><th>Fuser Kit Level</th><th>Transfer Kit Level</th><th>Document Feeder Kit Level</th></tr>';

    output.forEach(printer => {
        htmlContent += `<tr><td>${printer.name}</td><td>${printer.ip}</td><td>${printer.tonerLevelBlack}</td><td>${printer.tonerLevelCyan}</td><td>${printer.tonerLevelMagenta}</td><td>${printer.tonerLevelYellow}</td><td>${printer.drumLevelBlack}</td><td>${printer.drumLevelCyan}</td><td>${printer.drumLevelMagenta}</td><td>${printer.drumLevelYellow}</td><td>${printer.fuserKitLevel}</td><td>${printer.transferKitLevel}</td><td>${printer.documentFeederKitLevel}</td></tr>`;
    });

    htmlContent += '</table>';

    let mailOptions = {
        from: 'it2@homart.com.au', // sender address
        to: 'it2@homart.com.au', // list of receivers
        subject: '', // Subject line
        html: htmlContent // html body
    };

    try {
        let info = await transporter.sendMail(mailOptions);
        console.log('Message sent: %s', info.messageId);
    } catch (error) {
        console.error(error);
    }
};


// Fetch printer details immediately and then every 10 minutes only if it is the master cluster or master node or running on single instance
if (cluster.isMaster || (pm2 && pm2.process && pm2.process.pm_id === 0) || (!cluster.isWorker && !pm2)) {
    fetchPrinterDetails();
    setInterval(fetchPrinterDetails, 600000);
}

exports.getHomartPrinterTonerLevel = async (req, res, next) => {
    try {
        await sendEmail(output);
        res.json(output);
    } catch (error) {
        next(error);
    }
};
