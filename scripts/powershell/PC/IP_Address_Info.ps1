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
    # Ping the IP address with a timeout of 2 seconds
    try {
        $pingResults = Test-Connection -ComputerName $ip -Count 1 -TimeToLive 2 -ErrorAction Stop
        $ping = $true
        # If the ping is successful, retrieve the hostname
        try {
            $dns = [System.Net.Dns]::GetHostEntry($ip)
            $hostname = $dns.HostName
        } catch {
            continue
        }
        # Create a PSObject for the result
        $result = New-Object PSObject -Property @{
            "IP Address" = $ip
            "Hostname" = $hostname
        }
        # Output progress to the console
        Write-Output "Processed: IP Address: $ip, Hostname: $hostname"
        # Append the result to the CSV file
        try {
            $result | Export-Csv -Path $csvPath -NoTypeInformation -Append -ErrorAction Stop
        } catch {
            Write-Output "Failed to write to CSV file: $_"
        }
    } catch {
        continue
    }
}

# Prevent window from closing
Read-Host -Prompt "Press Enter to exit"
