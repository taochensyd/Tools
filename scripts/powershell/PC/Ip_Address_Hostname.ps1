# Define the subnet
$subnet = "192.168.0"

# Define the path to the CSV file
$csvPath = 'D:\Powershell_Script\Output\IP_Address_Ping.csv'

# Check if the output directory exists, if not, create it
if (!(Test-Path -Path (Split-Path -Path $csvPath))) {
    New-Item -ItemType Directory -Force -Path (Split-Path -Path $csvPath)
}

# Loop through all possible IP addresses in the subnet
for ($i=1; $i -le 254; $i++) {
    $ip = "$subnet.$i"
    # Start a new job for each ping
    Start-Job -ScriptBlock {
        param($ip, $csvPath)
        # Ping the IP address and retrieve the hostname
        try {
            $pingResults = Test-Connection -ComputerName $ip -Count 1 -TimeToLive 2 -ErrorAction Stop
            $ping = $true
            try {
                $dns = [System.Net.Dns]::GetHostEntry($ip)
                $hostname = $dns.HostName
            } catch {
                return
            }
            # Create a PSObject for the result
            $result = New-Object PSObject -Property @{
                "IP Address" = $ip
                "Hostname" = $hostname
            }
            # Append the result to the CSV file
            try {
                $result | Export-Csv -Path $csvPath -NoTypeInformation -Append -ErrorAction Stop
            } catch {
                Write-Output "Failed to write to CSV file: $_"
            }
        } catch {
            return
        }
    } -ArgumentList $ip, $csvPath | Out-Null

    # Output progress to the console
    Write-Progress -Activity "Pinging IP Addresses" -Status "$i out of 254" -PercentComplete (($i / 254) * 100)
}

# Get all jobs
$jobs = Get-Job

# Output progress to the console for job completion
for ($i=0; $i -lt $jobs.Count; $i++) {
    # Wait for the job to complete and then remove it
    Wait-Job -Job $jobs[$i] | Remove-Job

    # Output progress to the console
    Write-Progress -Activity "Completing Jobs" -Status "$($i + 1) out of $($jobs.Count)" -PercentComplete ((($i + 1) / $jobs.Count) * 100)
}

# Prevent window from closing
Read-Host -Prompt "Press Enter to exit"
