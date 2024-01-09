$Hosts = @("SERVER24", "SERVER25", "H02", "H04", "H05", "H08", "H09", "H10", "H11", "H12", "H16", "H19", "H14-UPJOHN1", "H15-UPJOHN2", "H18")
$recipients = @("it2@homart.com.au")
# $recipients = @("it2@homart.com.au")
$statuses = @()  # Array to capture all replication statuses
$titleStatus = "Normal"

# Initialize body with table headers
$body = "<h3>VM Replication Health Report</h3>
<table border='1'>
<tr>
    <th>Time</th>
    <th>Server Name</th>
    <th>VM Name</th>
    <th>Replication Health Status</th>
    <th>Replication State</th>
    <th>Replication Mode</th>
</tr>"

ForEach ($Server in $Hosts) {
    $result = Invoke-Command -ComputerName $Server {
        Get-VMReplication | Select-Object VMName, ComputerName, ReplicationHealth, ReplicationState, ReplicationMode
    }

    # Convert numeric ReplicationHealth to its string representation
    foreach ($vm in $result) {
        switch ($vm.ReplicationHealth) {
            1 { $vm.ReplicationHealth = "Normal" }
            2 { $vm.ReplicationHealth = "Warning" }
            3 { $vm.ReplicationHealth = "Critical" }
            default { $vm.ReplicationHealth = "Unknown" }
        }

        # Add the replication health to the statuses array
        $statuses += $vm.ReplicationHealth

        switch ($vm.ReplicationState) {
    0 { $vm.ReplicationState = "Disabled" }
    1 { $vm.ReplicationState = "ReadyForInitialReplication" }
    2 { $vm.ReplicationState = "InitialReplicationInProgress" }
    3 { $vm.ReplicationState = "WaitingForInitialReplication" }
    4 { $vm.ReplicationState = "Replicating" }
    5 { $vm.ReplicationState = "PreparedForFailover" }
    6 { $vm.ReplicationState = "FailedOverWaitingCompletion" }
    7 { $vm.ReplicationState = "FailedOver" }
    8 { $vm.ReplicationState = "Suspended" }
    9 { $vm.ReplicationState = "Error" }
    10 { $vm.ReplicationState = "WaitingForStartResynchronize" }
    11 { $vm.ReplicationState = "Resynchronizing" }
    12 { $vm.ReplicationState = "ResynchronizeSuspended" }
    13 { $vm.ReplicationState = "RecoveryInProgress" }
    14 { $vm.ReplicationState = "FailbackInProgress" }
    15 { $vm.ReplicationState = "FailbackComplete" }
    16 { $vm.ReplicationState = "WaitingForUpdateCompletion" }
    17 { $vm.ReplicationState = "UpdateError" }
    18 { $vm.ReplicationState = "WaitingForRepurposeCompletion" }
    19 { $vm.ReplicationState = "PreparedForSyncReplication" }
    20 { $vm.ReplicationState = "PreparedForGroupReverseReplication" }
    21 { $vm.ReplicationState = "FiredrillInProgress" }
    default { $vm.ReplicationState = "Unknown" }
}

switch ($vm.ReplicationMode) {
    0 { $vm.ReplicationMode = "None" }
    1 { $vm.ReplicationMode = "Primary" }
    2 { $vm.ReplicationMode = "Replica" }
    3 { $vm.ReplicationMode = "TestReplica" }
    4 { $vm.ReplicationMode = "ExtendedReplica" }
    default {$vm.ReplicationMode= "Unknown"}
}

        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        $body += "<tr>
            <td>$timestamp</td>
            <td>$Server</td>
            <td>$($vm.VMName)</td>
            <td>$($vm.ReplicationHealth)</td>
            <td>$($vm.ReplicationState)</td>
            <td>$($vm.ReplicationMode)</td>
        </tr>"

        if ($vm.ReplicationHealth -ne "Normal") {
            $titleStatus = $vm.ReplicationHealth
        }
    }
}

    $logTitle = "$titleStatus - VM Replication Health Report - " + (Get-Date -Format "yyyy-MM-dd HH:mm:ss")

$body += "</table>"

# $currentHour = (Get-Date).Hour

# Testing
#if (($currentHour -ge 9 -and $currentHour -lt 19) -or ($statuses -contains "Critical" -or $statuses -contains "Warning" -or $statuses -contains "Unknown")) {
#	$recipients = @("it2@homart.com.au")    
#	Send-MailMessage -From 'VM Replication Health Report <it2@homart.com.au>' -To $recipients -Subject $logTitle -Body $body -BodyAsHtml -SmtpServer 'homart-com-au.mail.protection.outlook.com'
#	exit
#}

# Window Task scheduler will run at 8:30 AM daily
#if (($currentHour -ge 8 -and $currentHour -lt 9) -or ($statuses -contains "Critical" -or $statuses -contains "Warning" -or $statuses -contains "Unknown")) {
    Send-MailMessage -From 'VM Replication Health Report <it2@homart.com.au>' -To $recipients -Subject $logTitle -Body $body -BodyAsHtml -SmtpServer 'homart-com-au.mail.protection.outlook.com'
#}
