const { exec } = require('child_process');

exports.postReplicationHealth = (req, res) => {
    console.log(req.body);

    exec('powershell.exe D:\\Tao\\Tools\\Tools\\scripts\\powershell\\Server\\RDS-SessionStatus.ps1', (error, stdout, stderr) => {
        if (error) {
            console.error(`exec error: ${error}`);
            return;
        }
        console.log(`stdout: ${stdout}`);
        console.error(`stderr: ${stderr}`);
    });

    res.send('Data received successfully.');
};
