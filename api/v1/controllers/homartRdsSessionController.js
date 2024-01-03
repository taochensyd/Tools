const { Shell } = require('node-powershell');

exports.getRdsSessionStatus = (req, res) => {
    let ps = new Shell({
        executionPolicy: 'Bypass',
        noProfile: true
    });

    ps.addCommand(`. ../../../scripts/powershell/Server/RDS_SessionStatus.ps1`);

    ps.invoke()
        .then(output => {
            let messages = output.split("\n\n").filter(msg => msg.trim() !== '');
            let result = messages.map(message => {
                let [server, ...status] = message.split("\n");
                return {
                    server: server.trim(),
                    status: status.join("\n").trim()
                };
            });
            res.json(result);
        })
        .catch(err => {
            res.json({ error: err });
        });
};
