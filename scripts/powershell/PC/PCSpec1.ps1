# # Define the PCs
# # $pcs = @("AD01", "RDSIS", "F01", "PC894", "RDS03", "PC832", "AD02", "PC851", "PC1003", "PC888", "PC1005", "PC892", "PC812", "PC841", "PC836", "PC875", "PC871", "SERVER10", "PC837", "PC848", "PC823", "PC844", "PC868", "PC847", "PC846", "PC833", "PC866A", "PC830", "PC845", "PC1014", "PC834", "PC874", "PC849", "PC873", "PC860", "PC886", "PC1012", "PC831", "PC861", "PC890", "SERVER17", "PC828", "PC835", "PC7004", "PC870", "PC1006", "PC862", "PC208", "PC891", "PC1010", "PC826", "PC865", "PC887", "PC880", "PC838", "PC885", "PC882", "PC881", "PC7009", "PC829", "PC1008", "SERVER14", "PC824", "SERVER12", "PC889", "PC843", "H07", "H08", "PC1009", "IBANKING", "MYOB2", "MYOB", "H10", "RDSAPP01", "HOMART-L102", "HOMART-EA", "SERVER24", "HOMART-JY-SPRO7", "H09", "PC852", "PC825", "H04", "HOMART_GM_LAPTO", "SERVER13A", "RDS04", "RDS05", "HOMART-L103", "PC842", "HOMART-L105", "RDSAPP02", "PC1007", "PC1002", "PC820", "TAB001", "TAB002", "TAB004", "H02", "TAB003", "PC7008", "H06", "H11", "H12", "PC822", "PC850", "HOMART-GM", "PC872", "PC203", "SERVER25", "PC896", "PC897", "HOMART-L104", "PC839", "HOMART-L107", "PC867", "HOMART-L101", "RDSAPP03", "H05", "HOMART-L109", "PC1013", "PC876", "HOMART_GM2", "H16", "HOMART-L108", "HOMART-L111", "HOMART-L112", "H14-UPJOHN1", "H15-UPJOHN2", "PC878", "PC7002", "JYPC", "PC883", "H17", "PC827", "MYOB3", "HOMART-L114", "PC863", "HOMART-L106", "PC877", "SAP02", "RDS01", "H19", "RDS06", "PC1015", "PC1016", "PC-898", "RDS02", "CLOCKONAPP", "RDS08", "HOMART-L115", "H18", "RDS07", "HOMART-L113", "PC7005", "RDS09", "HOMART-L116", "F01A")

# $pcs = @("AD01", "RDSIS", "F01")

# # Define the credentials
# $username = "hpadmin3"
# $password = ConvertTo-SecureString "Mine@Zoom65" -AsPlainText -Force
# $credential = New-Object System.Management.Automation.PSCredential($username, $password)

# # Run the commands on each server in parallel
# $results = $pcs | ForEach-Object -Parallel {
#     # Ping the PC first
#     $ping = Test-Connection -ComputerName $_ -Count 4 -Quiet

#     # If the PC responds to the ping, gather information
#     if ($ping) {
#         Write-Host "Gathering information for $_"

#         # Use Invoke-Command with the -Credential parameter
#         $info = Invoke-Command -ComputerName $_ -Credential $using:credential -ScriptBlock {
#             # Get the information
#             $hostname = hostname
#             $model = (Get-WmiObject -Class Win32_ComputerSystem).Model
            
#             # Updated CPU Information Processing
#             $cpuInfo = Get-WmiObject -Class Win32_Processor
#             $uniqueCpuInfo = $cpuInfo | Select-Object -Unique -Property Name, NumberOfCores, NumberOfLogicalProcessors, MaxClockSpeed
#             $cpuCount = $cpuInfo.Count
#             if ($uniqueCpuInfo.Count -gt 0) {  # Added check
#                 $cpuCount = $cpuCount / $uniqueCpuInfo.Count
#             }
#             $cpus = "$cpuCount * $($uniqueCpuInfo.Name)`n$($uniqueCpuInfo.NumberOfCores) Cores`n$($uniqueCpuInfo.NumberOfLogicalProcessors) Threads`n$($uniqueCpuInfo.MaxClockSpeed) MHz"  # Updated

#             $totalRam = [math]::Round((Get-WmiObject -Class Win32_ComputerSystem).TotalPhysicalMemory / 1GB)
#             $ramSpeed = (Get-WmiObject -Class Win32_PhysicalMemory | Select-Object -First 1).Speed
#             $totalSlots = (Get-WmiObject -Class Win32_PhysicalMemoryArray).MemoryDevices
#             $usedSlots = (Get-WmiObject -Class Win32_PhysicalMemory).Count
#             $ramSlots = "$usedSlots/$totalSlots slots"
            
#             $disks = Get-WmiObject -Class Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 } | ForEach-Object {
#                 "DeviceID: $($_.DeviceID)`nSize: $([math]::Round($_.Size / 1GB)) GB`nFree Space: $([math]::Round($_.FreeSpace / 1GB)) GB"
#             }
#             $disks = $disks -join "`n`n"  # Updated

#             # Create a custom object with the information
#             $customObject = [PSCustomObject]@{
#                 Hostname = $hostname
#                 Model = $model
#                 CPUs = $cpus
#                 RAMGB = $totalRam
#                 RAMSlots = $ramSlots
#                 RAMSpeedMHz = $ramSpeed
#                 Disks = $disks
#             }

#             return $customObject
#         }

#         Write-Host "Information gathered for $_"
#         return $info
#     } else {
#         Write-Host "$_ did not respond to ping. Skipping..."
#     }
# }

# # Export the results to a CSV file
# $results | Export-Csv -Path 'D:\Powershell_Script\Output\PCSpec1.csv' -NoTypeInformation

# Write-Host "Results exported to D:\Powershell_Script\Output\PCSpec1.csv"

# # Prevent window from closing
# Read-Host -Prompt "Press Enter to exit"




# $pcs = @("AD01", "RDSIS", "F01", "PC894", "RDS03", "PC832", "AD02", "PC851", "PC1003", "PC888", "PC1005", "PC892", "PC812", "PC841", "PC836", "PC875", "PC871", "SERVER10", "PC837", "PC848", "PC823", "PC844", "PC868", "PC847", "PC846", "PC833", "PC866A", "PC830", "PC845", "PC1014", "PC834", "PC874", "PC849", "PC873", "PC860", "PC886", "PC1012", "PC831", "PC861", "PC890", "SERVER17", "PC828", "PC835", "PC7004", "PC870", "PC1006", "PC862", "PC208", "PC891", "PC1010", "PC826", "PC865", "PC887", "PC880", "PC838", "PC885", "PC882", "PC881", "PC7009", "PC829", "PC1008", "SERVER14", "PC824", "SERVER12", "PC889", "PC843", "H07", "H08", "PC1009", "IBANKING", "MYOB2", "MYOB", "H10", "RDSAPP01", "HOMART-L102", "HOMART-EA", "SERVER24", "HOMART-JY-SPRO7", "H09", "PC852", "PC825", "H04", "HOMART_GM_LAPTO", "SERVER13A", "RDS04", "RDS05", "HOMART-L103", "PC842", "HOMART-L105", "RDSAPP02", "PC1007", "PC1002", "PC820", "TAB001", "TAB002", "TAB004", "H02", "TAB003", "PC7008", "H06", "H11", "H12", "PC822", "PC850", "HOMART-GM", "PC872", "PC203", "SERVER25", "PC896", "PC897", "HOMART-L104", "PC839", "HOMART-L107", "PC867", "HOMART-L101", "RDSAPP03", "H05", "HOMART-L109", "PC1013", "PC876", "HOMART_GM2", "H16", "HOMART-L108", "HOMART-L111", "HOMART-L112", "H14-UPJOHN1", "H15-UPJOHN2", "PC878", "PC7002", "JYPC", "PC883", "H17", "PC827", "MYOB3", "HOMART-L114", "PC863", "HOMART-L106", "PC877", "SAP02", "RDS01", "H19", "RDS06", "PC1015", "PC1016", "PC-898", "RDS02", "CLOCKONAPP", "RDS08", "HOMART-L115", "H18", "RDS07", "HOMART-L113", "PC7005", "RDS09", "HOMART-L116", "F01A")



# $pcs = @("AD01", "RDSIS", "F01", "PC894", "RDS03", "PC832", "AD02", "PC851", "PC1003", "PC888")
# $username = 'hpadmin3'
# $password = ConvertTo-SecureString 'Mine@Zoom65' -AsPlainText -Force
# $credential = [PSCredential]::new($username, $password)

# # Use ForEach-Object -Parallel to process the PCs in parallel
# $results = $pcs | ForEach-Object -Parallel {
#     $pc = $_

#     # Gather information for each PC
#     $info = Invoke-Command -ComputerName $pc -Credential $using:credential -ScriptBlock {
#         # Get the information
#         $hostname = hostname
#         $model = (Get-CimInstance -ClassName Win32_ComputerSystem).Model

#         # Updated CPU Information Processing
#         $cpuInfo = Get-CimInstance -ClassName Win32_Processor
#         $uniqueCpuInfo = $cpuInfo | Select-Object -Unique -Property Name, NumberOfCores, NumberOfLogicalProcessors, MaxClockSpeed
#         $cpuCount = $cpuInfo.Count
#         if ($uniqueCpuInfo.Count -gt 0) {  # Added check
#             $cpuCount = $cpuCount / $uniqueCpuInfo.Count
#         }
#         $cpus = "$cpuCount * $($uniqueCpuInfo.Name)`n$($uniqueCpuInfo.NumberOfCores) Cores`n$($uniqueCpuInfo.NumberOfLogicalProcessors) Threads`n$($uniqueCpuInfo.MaxClockSpeed) MHz"  # Updated

#         $totalRam = [math]::Round((Get-CimInstance -ClassName Win32_ComputerSystem).TotalPhysicalMemory / 1GB)
#         $ramSpeed = (Get-CimInstance -ClassName Win32_PhysicalMemory | Select-Object -First 1).Speed
#         $totalSlots = (Get-CimInstance -ClassName Win32_PhysicalMemoryArray).MemoryDevices
#         $usedSlots = (Get-CimInstance -ClassName Win32_PhysicalMemory).Count
#         $ramSlots = "$usedSlots/$totalSlots slots"

#         $disks = Get-CimInstance -ClassName Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 } | ForEach-Object {
#             @{
#                 DeviceID   = $_.DeviceID
#                 Size       = [math]::Round($_.Size / 1GB)
#                 FreeSpace  = [math]::Round($_.FreeSpace / 1GB)
#             }
#         }
        
#         # Return a hashtable with the information
#         @{
#             Hostname   = $hostname
#             Model      = $model
#             CPUs       = $cpus
#             TotalRAM   = "$totalRam GB"
#             RAMSpeed   = "$ramSpeed MHz"
#             RAMSlots   = $ramSlots
#             Disks      = $disks
#         }
#     }

#     # Output the information for this PC
#     return @{
#         PC   = $pc
#         Info = $info
#     }
# }

# # Export the results to a CSV file
# $results | Export-Csv -Path 'D:\Powershell_Script\Output\PCSpec1.csv' -NoTypeInformation

# Write-Host "Results exported to D:\Powershell_Script\Output\PCSpec1.csv"

# # Prevent window from closing
# Read-Host -Prompt "Press Enter to exit"



$pcs = @("AD01", "RDSIS", "F01", "PC894", "RDS03", "PC832", "AD02", "PC851", "PC1003", "PC888")
$username = 'hpadmin3'
$password = ConvertTo-SecureString 'Mine@Zoom65' -AsPlainText -Force
$credential = [PSCredential]::new($username, $password)

# Use ForEach-Object -Parallel to process the PCs in parallel
$results = $pcs | ForEach-Object -Parallel {
    $pc = $_

    # Gather information for each PC
    $info = Invoke-Command -ComputerName $pc -Credential $using:credential -ScriptBlock {
        # Get the information
        $hostname = hostname
        $model = (Get-CimInstance -ClassName Win32_ComputerSystem).Model

        # Updated CPU Information Processing
        $cpuInfo = Get-CimInstance -ClassName Win32_Processor
        $uniqueCpuInfo = $cpuInfo | Select-Object -Unique -Property Name, NumberOfCores, NumberOfLogicalProcessors, MaxClockSpeed
        $cpuCount = $cpuInfo.Count
        if ($uniqueCpuInfo.Count -gt 0) {  # Added check
            $cpuCount = $cpuCount / $uniqueCpuInfo.Count
        }
        $cpus = "$cpuCount * $($uniqueCpuInfo.Name)`n$($uniqueCpuInfo.NumberOfCores) Cores`n$($uniqueCpuInfo.NumberOfLogicalProcessors) Threads`n$($uniqueCpuInfo.MaxClockSpeed) MHz"  # Updated

        $totalRam = [math]::Round((Get-CimInstance -ClassName Win32_ComputerSystem).TotalPhysicalMemory / 1GB)
        $ramSpeed = (Get-CimInstance -ClassName Win32_PhysicalMemory | Select-Object -First 1).Speed
        $totalSlots = (Get-CimInstance -ClassName Win32_PhysicalMemoryArray).MemoryDevices
        $usedSlots = (Get-CimInstance -ClassName Win32_PhysicalMemory).Count
        $ramSlots = "$usedSlots/$totalSlots slots"

        # Get disk information including type (HDD or SSD)
        $disks = Get-CimInstance -ClassName Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 } | ForEach-Object {
            # Get corresponding physical disk info for the logical disk
            $physicalDisk = Get-WmiObject Win32_DiskDrive | Where-Object { $_.DeviceID.replace("\\\\.\\","") -eq $_.DeviceID }
            # Determine disk type (HDD or SSD)
            if ($physicalDisk.MediaType -like "*SSD*") {
                $diskType = "SSD"
            } else {
                $diskType = "HDD"
            }
            @{
                DeviceID   = $_.DeviceID
                Size       = [math]::Round($_.Size / 1GB)
                FreeSpace  = [math]::Round($_.FreeSpace / 1GB)
                DiskType   = $diskType
            }
        }
        
        # Return a hashtable with the information
        @{
            Hostname   = $hostname
            Model      = $model
            CPUs       = $cpus
            TotalRAM   = "$totalRam GB"
            RAMSpeed   = "$ramSpeed MHz"
            RAMSlots   = $ramSlots
            Disks      = $disks
        }
    }

    # Output the information for this PC
    return @{
        PC   = $pc
        Info = $info
    }
}

# Export the results to a CSV file
$results | Export-Csv -Path 'D:\Powershell_Script\Output\PCSpec1.csv' -NoTypeInformation

Write-Host "Results exported to D:\Powershell_Script\Output\PCSpec1.csv"

# Prevent window from closing
Read-Host -Prompt "Press Enter to exit"
