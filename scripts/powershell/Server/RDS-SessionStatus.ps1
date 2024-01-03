$servers = @("rds01", "rds02", "rds03", "rds04", "rds05", "rds06", "rds07", "rds09", "rdsapp01")

foreach ($server in $servers) {
    Write-Output ""
    Write-Output $server
    if (Test-Connection -ComputerName $server -Count 1 -Quiet -TimeToLive 3) {
        qwinsta /server:$server
    } else {
        Write-Output "Ping failed"
    }
}

Read-Host -Prompt "Press Any Key to exit"