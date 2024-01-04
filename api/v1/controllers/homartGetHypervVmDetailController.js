const shell = require('node-powershell');

exports.hypervVmDetail = async (req, res) => {

    res.send("ok")

    /*
        TODO
        1. route
        2. PowerShell Command
    */

    let ps = new shell({
        executionPolicy: 'Bypass',
        noProfile: true
    });

    ps.addCommand(`
        $servers = "H02", "H04", "H05", "H08", "H09", "H10", "H16", "H17", "H19", "H20", "H21"
        $results = @()
        foreach ($server in $servers) {
            $session = New-PSSession -ComputerName $server
            $vmNames = Invoke-Command -Session $session -ScriptBlock {
                Import-Module Hyper-V
                Get-VM | Select-Object -ExpandProperty Name
            }
            Remove-PSSession -Session $session
            $results += New-Object PSObject -Property @{
                Server = $server
                VMNames = $vmNames -join ', '
            }
        }
        $results
    `);

    try {
        let result = await ps.invoke();
        res.send(result);
    } catch (err) {
        console.error(err);
        res.status(500).send(err);
    }

    ps.dispose();
}
