# Define the server names
$servers = "H02", "H04", "H05", "H08", "H09", "H10", "H16", "H17", "H19", "H20", "H21", "H14-UPJOHN1", "H15-UPJOHN2", "H18"

# Create an empty array to store the results
$results = @()

# Loop through each server
foreach ($server in $servers) {
    # Establish a remote session
    $session = New-PSSession -ComputerName $server

    # Get the VM details
    $vmDetails = Invoke-Command -Session $session -ScriptBlock {
        # Import the Hyper-V module
        Import-Module Hyper-V

        # Get the VM details
        Get-VM | ForEach-Object {
            $vm = $_
            $vmName = $vm.Name
            $cpuCores = $vm.ProcessorCount
            $ramAssigned = if ($vm.MemoryAssigned -is [array]) { $vm.MemoryAssigned[0]/1GB } else { $vm.MemoryAssigned/1GB }
            $dynamicMemory = $vm.DynamicMemoryEnabled
            $vhdxSize = (Get-VMHardDiskDrive -VMName $vmName | Get-VHD).FileSize
            if ($vhdxSize -is [array]) { $vhdxSize = $vhdxSize[0] }
            $vhdxSize = $vhdxSize/1GB
            $creationTime = $vm.CreationTime

            # Create a custom object to hold the VM details
            New-Object PSObject -Property @{
                VMName = $vmName
                CPUCores = $cpuCores
                RAMAssignedGB = $ramAssigned
                DynamicMemoryEnabled = $dynamicMemory
                VHDXSizeGB = $vhdxSize
                CreationTime = $creationTime
            }
        }
    }

    # Close the remote session
    Remove-PSSession -Session $session

    # Add the server and VM details to the results array
    foreach ($vmDetail in $vmDetails) {
        $results += $vmDetail | Add-Member -MemberType NoteProperty -Name "Server" -Value $server -PassThru
    }
}

# Define the CSS
$css = @"
<style>
table {
  border-collapse: collapse;
  width: 100%;
}
th, td {
  text-align: left;
  padding: 8px;
  border: 1px solid #ddd;
  white-space: pre;  # This will preserve newlines in table cells
}
tr:nth-child(even){background-color: #f2f2f2}
th {
  background-color: #d3d3d3;
  color: black;
}
</style>
"@

# Convert the results to HTML
$htmlBody = $results | ConvertTo-Html -Property Server, VMName, CPUCores, RAMAssignedGB, DynamicMemoryEnabled, VHDXSizeGB, CreationTime -Head $css | Out-String

# Define the email parameters
$fromEmail = 'it2@homart.com.au'
$toEmail = 'taochensyd@gmail.com'
$subject = "VM List"
$smtpServer = 'homart-com-au.mail.protection.outlook.com'

# Send the email
Send-MailMessage -From $fromEmail -To $toEmail -Subject $subject -Body $htmlBody -BodyAsHtml -SmtpServer $smtpServer

# Pause the script at the end so the window doesn't close
Read-Host -Prompt "Press Enter to exit"
