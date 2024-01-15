# Define the servers
$servers = @("AD01", "AD02", "HPS1", "SAP02", "MYOB", "MYOB2", "MYOB3", "F01", "Server10", "RDSIS", "ClockOn", "ClockOnApp", "HCController",  "RDS01", "RDS02", "RDS03", "RDS04", "RDS05", "RDS06", "RDS07", "RDS08", "RDS09", "RDSAPP01", "SERVER25", "H02", 
"H04", "H05", "H06", "H07", "H08", "H09", "H10", "H14-UPJOHN1", "H15-UPJOHN2", "H16", "H17", "H18", "H19", "H20", "H21")

# Initialize the results array
$results = @()

# Initialize the count of offline servers
$offlineCount = 0

foreach ($server in $servers) {
    # Ping the server
    $ping = Test-Connection -ComputerName $server -Count 3 -Quiet

    # Initialize a new result object
    $result = New-Object PSObject

    # Add the server name to the result
    $result | Add-Member -MemberType NoteProperty -Name "Server Name" -Value $server

    if ($ping) {
        # The server is online
        $result | Add-Member -MemberType NoteProperty -Name "Status" -Value "Online"

        # Calculate the average latency and round to 2 decimal places
        $latency = (Test-Connection -ComputerName $server -Count 3).ResponseTime | Measure-Object -Average
        $result | Add-Member -MemberType NoteProperty -Name "Latency" -Value ([math]::Round($latency.Average, 2))

        # Get the IP address
        $ip = (Test-Connection -ComputerName $server -Count 1).IPV4Address.IPAddressToString
        $result | Add-Member -MemberType NoteProperty -Name "IP Address" -Value $ip
    } else {
        # The server is offline
        $result | Add-Member -MemberType NoteProperty -Name "Status" -Value "Offline"
        $result | Add-Member -MemberType NoteProperty -Name "Latency" -Value "N/A"
        $result | Add-Member -MemberType NoteProperty -Name "IP Address" -Value "N/A"

        # Increment the count of offline servers
        $offlineCount++
    }

    # Add the result to the results array
    $results += $result
}

# Define the HTML style
$style = @"
<style>
table {
  border-collapse: collapse;
  width: 100%;
}
th, td {
  border: 1px solid #ddd;
  padding: 8px;
}
th {
  padding-top: 12px;
  padding-bottom: 12px;
  text-align: left;
  background-color: #4CAF50;
  color: white;
}
tr.offline {
  background-color: #f2dede;
}
</style>
"@

# Convert the results to an HTML table
$html = $results | ConvertTo-Html -Property "Server Name", "Status", "Latency", "IP Address" -Head $style | Out-String

# Add the 'offline' class to the rows that correspond to offline servers
$html = $html -replace '(?<=<tr><td>Offline</td>)', ' class="offline"'

# Define the email parameters
$fromEmail = 'it2@homart.com.au'
$toEmail = 'taochensyd@gmail.com'
$smtpServer = 'homart-com-au.mail.protection.outlook.com'

# Determine the subject based on the status of the servers
if ($offlineCount -eq 0) {
    $subject = "Server Status: All Online"
} else {
    $subject = "Server Status: $offlineCount/" + $servers.Count + " is Offline"
}

# Create the email message
$message = New-Object System.Net.Mail.MailMessage
$message.From = $fromEmail
$message.To.Add($toEmail)
$message.Subject = $subject
$message.Body = $html
$message.IsBodyHtml = $true

# Send the email
$smtp = New-Object Net.Mail.SmtpClient($smtpServer)
$smtp.Send($message)
