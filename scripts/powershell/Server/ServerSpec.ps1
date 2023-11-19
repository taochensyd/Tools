# # Define the servers
# $servers = @("H02", "H04", "H05", "H08", "H09", "H10", "H11", "H12", "H14-UPJOHN1", "H15-UPJOHN2", "H16", "H17", "H18", "H19", "SERVER24", "SERVER25")
# # Define the credentials
# $username = "hpadmin3"
# $password = ConvertTo-SecureString "Mine@Zoom65" -AsPlainText -Force
# $credential = New-Object System.Management.Automation.PSCredential($username, $password)

# # Create an array to hold the results
# $results = @()

# # Loop through each server
# foreach ($server in $servers) {
#     Write-Host "Gathering information for $server"

#     # Use Invoke-Command with the -Credential parameter
#     $info = Invoke-Command -ComputerName $server -Credential $credential -ScriptBlock {
#         # Get the information
#         $hostname = hostname
#         $runningVMs = (Get-VM | ForEach-Object { $_.Name }) -join "`n"
#         $model = (Get-WmiObject -Class Win32_ComputerSystem).Model
        
#                 # Updated CPU Information Processing
#         $cpuInfo = Get-WmiObject -Class Win32_Processor
#         $uniqueCpuInfo = $cpuInfo | Select-Object -Unique -Property Name, NumberOfCores, NumberOfLogicalProcessors, MaxClockSpeed
#         $cpuCount = $cpuInfo.Count
#         if ($uniqueCpuInfo.Count -gt 0) {  # Added check
#             $cpuCount = $cpuCount / $uniqueCpuInfo.Count
#         }
#         $cpus = "$cpuCount * $($uniqueCpuInfo.Name)`n$($uniqueCpuInfo.NumberOfCores) Cores`n$($uniqueCpuInfo.NumberOfLogicalProcessors) Threads`n$($uniqueCpuInfo.MaxClockSpeed) MHz"  # Updated

#         $totalRam = [math]::Round((Get-WmiObject -Class Win32_ComputerSystem).TotalPhysicalMemory / 1GB)
#         $ramSpeed = (Get-WmiObject -Class Win32_PhysicalMemory | Select-Object -First 1).Speed
#         $totalSlots = (Get-WmiObject -Class Win32_PhysicalMemoryArray).MemoryDevices
#         $usedSlots = (Get-WmiObject -Class Win32_PhysicalMemory).Count
#         $ramSlots = "$usedSlots/$totalSlots slots"
        
#         $disks = Get-WmiObject -Class Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 } | ForEach-Object {
#             "DeviceID: $($_.DeviceID)`nSize: $([math]::Round($_.Size / 1GB)) GB`nFree Space: $([math]::Round($_.FreeSpace / 1GB)) GB"
#         }
#         $disks = $disks -join "`n`n"  # Updated

#         # Create a custom object with the information
#         $customObject = [PSCustomObject]@{
#             Hostname = $hostname
#             VMs = $runningVMs
#             Model = $model
#             CPUs = $cpus
#             RAMGB = $totalRam
#             RAMSlots = $ramSlots
#             RAMSpeedMHz = $ramSpeed
#             Disks = $disks
#         }

#         return $customObject
#     }

#     # Add the result to the array
#     $results += $info

#     Write-Host "Information gathered for $server"
# }

# # Export the results to a CSV file
# $results | Export-Csv -Path 'D:\Powershell_Script\Output\ServerSpec.csv' -NoTypeInformation

# Write-Host "Results exported to D:\Powershell_Script\Output\ServerSpec.csv"



# Define the servers
$servers = @("H02", "H04", "H05", "H08", "H09", "H10", "H11", "H12", "H14-UPJOHN1", "H15-UPJOHN2", "H16", "H17", "H18", "H19", "SERVER24", "SERVER25")
# Define the credentials
$username = "hpadmin3"
$password = ConvertTo-SecureString "Mine@Zoom65" -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($username, $password)

# Run the commands on each server in parallel
$results = $servers | ForEach-Object -Parallel {
    Write-Host "Gathering information for $_"

    # Use Invoke-Command with the -Credential parameter
    $info = Invoke-Command -ComputerName $_ -Credential $using:credential -ScriptBlock {
        # Get the information
        $hostname = hostname
        $runningVMs = (Get-VM | ForEach-Object { $_.Name }) -join "`n"
        $model = (Get-WmiObject -Class Win32_ComputerSystem).Model
        
        # Updated CPU Information Processing
        $cpuInfo = Get-WmiObject -Class Win32_Processor
        $uniqueCpuInfo = $cpuInfo | Select-Object -Unique -Property Name, NumberOfCores, NumberOfLogicalProcessors, MaxClockSpeed
        $cpuCount = $cpuInfo.Count
        if ($uniqueCpuInfo.Count -gt 0) {  # Added check
            $cpuCount = $cpuCount / $uniqueCpuInfo.Count
        }
        $cpus = "$cpuCount * $($uniqueCpuInfo.Name)`n$($uniqueCpuInfo.NumberOfCores) Cores`n$($uniqueCpuInfo.NumberOfLogicalProcessors) Threads`n$($uniqueCpuInfo.MaxClockSpeed) MHz"  # Updated

        $totalRam = [math]::Round((Get-WmiObject -Class Win32_ComputerSystem).TotalPhysicalMemory / 1GB)
        $ramSpeed = (Get-WmiObject -Class Win32_PhysicalMemory | Select-Object -First 1).Speed
        $totalSlots = (Get-WmiObject -Class Win32_PhysicalMemoryArray).MemoryDevices
        $usedSlots = (Get-WmiObject -Class Win32_PhysicalMemory).Count
        $ramSlots = "$usedSlots/$totalSlots slots"
        
        $disks = Get-WmiObject -Class Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 } | ForEach-Object {
            "DeviceID: $($_.DeviceID)`nSize: $([math]::Round($_.Size / 1GB)) GB`nFree Space: $([math]::Round($_.FreeSpace / 1GB)) GB"
        }
        $disks = $disks -join "`n`n"  # Updated

        # Create a custom object with the information
        $customObject = [PSCustomObject]@{
            Hostname = $hostname
            VMs = $runningVMs
            Model = $model
            CPUs = $cpus
            RAMGB = $totalRam
            RAMSlots = $ramSlots
            RAMSpeedMHz = $ramSpeed
            Disks = $disks
        }

        return $customObject
    }

    Write-Host "Information gathered for $_"
    return $info
}

# Export the results to a CSV file
$results | Export-Csv -Path 'D:\Powershell_Script\Output\ServerSpec.csv' -NoTypeInformation

Write-Host "Results exported to D:\Powershell_Script\Output\ServerSpec.csv"

# Prevent window from closing
Read-Host -Prompt "Press Enter to exit"




