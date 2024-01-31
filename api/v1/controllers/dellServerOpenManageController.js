const puppeteer = require('puppeteer');

async function diskInfo(req, res) {
    let browser;
    try {
        browser = await puppeteer.launch({
            ignoreHTTPSErrors: true, // This will ignore certificate errors
        });
        const page = await browser.newPage();
        await page.goto('https://H06:1311', { waitUntil: 'networkidle2' });

        // Wait for the selectors to be available before typing
        await page.waitForSelector('input[name="user"]');
        await page.waitForSelector('input[name="password"]');
        await page.type('input[name="user"]', 'hpadmin3');
        await page.type('input[name="password"]', 'Mine@Zoom65');

        // Wait for the login button to be available before clicking
        await page.waitForSelector('#login_submit');
        await Promise.all([
            page.waitForNavigation(),
            page.click('#login_submit'),
        ]);

        // Now you are logged in and you can get the URL and HTML of the page
        let url = await page.url();
        let html = await page.content();

        res.send({url, html});
    } catch (error) {
        console.error(error);
        res.status(500).send({ error: 'An error occurred while trying to login.' });
    } finally {
        if (browser) {
            await browser.close();
        }
    }
}

module.exports = { diskInfo };
