# # # Predefined domain admin credentials (replace with your actual credentials)
# # $domainAdminUsername = "hpadmin3"
# # $domainAdminPassword = ConvertTo-SecureString "Mine@Zoom65" -AsPlainText -Force
# # $credentials = New-Object System.Management.Automation.PSCredential ($domainAdminUsername, $domainAdminPassword)

# # Write-Host "Credentials have been set."

# # # Specify the remote computer names
# # $PCName = @("AD01", "RDSIS", "F01", "PC894", "RDS03", "PC832", "AD02", "PC851", "PC1003", "PC888", "PC1005", "PC892", "PC812", "PC841", "PC836", "PC875", "PC871", "SERVER10", "PC837", "PC848", "PC823", "PC844", "PC868", "PC847", "PC846", "PC833", "PC866A", "PC830", "PC845", "PC1014", "PC834", "PC874", "PC849", "PC873", "PC860", "PC886", "PC1012", "PC831", "PC861", "PC890", "SERVER17", "PC828", "PC835", "PC7004", "PC870", "PC1006", "PC862", "PC208", "PC891", "PC1010", "PC826", "PC865", "PC887", "PC880", "PC838", "PC885", "PC882", "PC881", "PC7009", "PC829", "PC1008", "SERVER14", "PC824", "SERVER12", "PC889", "PC843", "H07", "H08", "PC1009", "IBANKING", "MYOB2", "MYOB", "H10", "RDSAPP01", "HOMART-L102", "HOMART-EA", "SERVER24", "HOMART-JY-SPRO7", "H09", "PC852", "PC825", "H04", "HOMART_GM_LAPTO", "SERVER13A", "RDS04", "RDS05", "HOMART-L103", "PC842", "HOMART-L105", "RDSAPP02", "PC1007", "PC1002", "PC820", "TAB001", "TAB002", "TAB004", "H02", "TAB003", "PC7008", "H06", "H11", "H12", "PC822", "PC850", "HOMART-GM", "PC872", "PC203", "SERVER25", "PC896", "PC897", "HOMART-L104", "PC839", "HOMART-L107", "PC867", "HOMART-L101", "RDSAPP03", "H05", "HOMART-L109", "PC1013", "PC876", "HOMART_GM2", "H16", "HOMART-L108", "HOMART-L111", "HOMART-L112", "H14-UPJOHN1", "H15-UPJOHN2", "PC878", "PC7002", "JYPC", "PC883", "H17", "PC827", "MYOB3", "HOMART-L114", "PC863", "HOMART-L106", "PC877", "SAP02", "RDS01", "H19", "RDS06", "PC1015", "PC1016", "PC-898", "RDS02", "CLOCKONAPP", "RDS08", "HOMART-L115", "H18", "RDS07", "HOMART-L113", "PC7005", "RDS09", "HOMART-L116", "F01A")


# # # Create an array to hold the job objects
# # $jobs = @()

# # # Launch jobs in parallel
# # foreach ($remoteComputer in $PCName) {
# #     $job = @{
# #         Name = $remoteComputer
# #         ScriptBlock = {
# #             param (
# #                 $remoteComputer,
# #                 $credentials
# #             )
            
# #             Write-Host "Processing $remoteComputer..."

# #             # Ping the remote computer 4 times to check for connectivity with a timeout of 5 seconds
# #             $pingJob = Test-Connection -ComputerName $remoteComputer -Count 4 -AsJob
# #             $pingResult = $null
# #             $pingJob | Wait-Job -Timeout 5
# #             if ($pingJob.State -eq 'Completed') {
# #                 $pingResult = $pingJob | Receive-Job
# #                 $pingJob | Remove-Job
# #             } else {
# #                 $pingJob | Stop-Job
# #                 $pingJob | Remove-Job
# #             }

# #             if ($pingResult) {
# #                 Write-Host "Ping successful for $remoteComputer. Collecting information..."

# #                 try {
# #                     # Get hostname, CPU name, total RAM, RAM slots, disk info, logged in username, and IP address
# #                     $hostname = (Get-WmiObject -Class Win32_ComputerSystem -ComputerName $remoteComputer -Credential $credentials).Name
# #                     $cpu = (Get-WmiObject -Class Win32_Processor -ComputerName $remoteComputer -Credential $credentials).Name
# #                     $ram = (Get-WmiObject -Class Win32_ComputerSystem -ComputerName $remoteComputer -Credential $credentials).TotalPhysicalMemory
# #                     $ramSlots = (Get-WmiObject -Class Win32_PhysicalMemoryArray -ComputerName $remoteComputer -Credential $credentials).MemoryDevices
# #                     $disk = Get-WmiObject -Class Win32_LogicalDisk -ComputerName $remoteComputer -Credential $credentials | Select-Object DeviceID, Size, FreeSpace
# #                     $loggedInUser = (Get-WmiObject -Class Win32_ComputerSystem -ComputerName $remoteComputer -Credential $credentials).UserName
# #                     $ipAddress = (Get-WmiObject -Class Win32_NetworkAdapterConfiguration -ComputerName $remoteComputer -Credential $credentials | Where-Object { $_.Description -like "*Ethernet*" -and $_.IPAddress -like "192.168.0.*" }).IPAddress

# #                     # Create a custom object to hold the collected information
# #                     $Output = [PSCustomObject]@{
# #                         Hostname         = $hostname
# #                         CPU              = $cpu
# #                         RAM              = $ram
# #                         RAMSlots         = $ramSlots
# #                         DiskInfo         = $disk
# #                         LoggedInUser     = $loggedInUser
# #                         IPAddress        = $ipAddress -join ', '
# #                     }
                    
# #                     # Return the custom object
# #                     return $Output
                
# #                     Write-Host "Information collected for $remoteComputer."
# #                 } catch {
# #                     Write-Host "Error collecting information for $remoteComputer. Error details: $($_.Exception.Message)"
# #                 }
# #             }
# #             else {
# #                 Write-Host "Ping failed or timed out for $remoteComputer. Skipping..."
# #             }
# #         }
# #         ArgumentList = $remoteComputer, $credentials
# #     }
    
# #     $jobs += Start-Job @job
# # }

# # # Wait for all jobs to complete
# # $jobs | Wait-Job

# # # Collect the results
# # $OutputArray = $jobs | ForEach-Object { Receive-Job -Job $_ }

# # # Remove the jobs
# # $jobs | Remove-Job

# # # Define the output file path
# # $outputFilePath = "D:\PowerShell_Script\Output\ComputerInfo.csv"

# # Write-Host "Output file path defined as $outputFilePath."

# # # Export the collected information to a CSV file
# # $OutputArray | Export-Csv -Path $outputFilePath -NoTypeInformation

# # Write-Host "Information exported to $outputFilePath."




# # $PCName = @("AD01", "RDSIS", "F01", "PC894", "RDS03", "PC832", "AD02", "PC851", "PC1003", "PC888", "PC1005", "PC892", "PC812", "PC841", "PC836", "PC875", "PC871", "SERVER10", "PC837", "PC848", "PC823", "PC844", "PC868", "PC847", "PC846", "PC833", "PC866A", "PC830", "PC845", "PC1014", "PC834", "PC874", "PC849", "PC873", "PC860", "PC886", "PC1012", "PC831", "PC861", "PC890", "SERVER17", "PC828", "PC835", "PC7004", "PC870", "PC1006", "PC862", "PC208", "PC891", "PC1010", "PC826", "PC865", "PC887", "PC880", "PC838", "PC885", "PC882", "PC881", "PC7009", "PC829", "PC1008", "SERVER14", "PC824", "SERVER12", "PC889", "PC843", "H07", "H08", "PC1009", "IBANKING", "MYOB2", "MYOB", "H10", "RDSAPP01", "HOMART-L102", "HOMART-EA", "SERVER24", "HOMART-JY-SPRO7", "H09", "PC852", "PC825", "H04", "HOMART_GM_LAPTO", "SERVER13A", "RDS04", "RDS05", "HOMART-L103", "PC842", "HOMART-L105", "RDSAPP02", "PC1007", "PC1002", "PC820", "TAB001", "TAB002", "TAB004", "H02", "TAB003", "PC7008", "H06", "H11", "H12", "PC822", "PC850", "HOMART-GM", "PC872", "PC203", "SERVER25", "PC896", "PC897", "HOMART-L104", "PC839", "HOMART-L107", "PC867", "HOMART-L101", "RDSAPP03", "H05", "HOMART-L109", "PC1013", "PC876", "HOMART_GM2", "H16", "HOMART-L108", "HOMART-L111", "HOMART-L112", "H14-UPJOHN1", "H15-UPJOHN2", "PC878", "PC7002", "JYPC", "PC883", "H17", "PC827", "MYOB3", "HOMART-L114", "PC863", "HOMART-L106", "PC877", "SAP02", "RDS01", "H19", "RDS06", "PC1015", "PC1016", "PC-898", "RDS02", "CLOCKONAPP", "RDS08", "HOMART-L115", "H18", "RDS07", "HOMART-L113", "PC7005", "RDS09", "HOMART-L116", "F01A")


# $domainAdminUsername = "hpadmin3"
# $domainAdminPassword = ConvertTo-SecureString "Mine@Zoom65" -AsPlainText -Force
# $credentials = New-Object System.Management.Automation.PSCredential ($domainAdminUsername, $domainAdminPassword)

# # $PCName = @("AD01", "RDSIS", "F01")
# $PCName = @("AD01", "RDSIS", "F01", "PC894", "RDS03", "PC832", "AD02", "PC851", "PC1003", "PC888", "PC1005", "PC892", "PC812", "PC841", "PC836", "PC875", "PC871", "SERVER10", "PC837", "PC848", "PC823", "PC844", "PC868", "PC847", "PC846", "PC833", "PC866A", "PC830", "PC845", "PC1014", "PC834", "PC874", "PC849", "PC873", "PC860", "PC886", "PC1012", "PC831", "PC861", "PC890", "SERVER17", "PC828", "PC835", "PC7004", "PC870", "PC1006", "PC862", "PC208", "PC891", "PC1010", "PC826", "PC865", "PC887", "PC880", "PC838", "PC885", "PC882", "PC881", "PC7009", "PC829", "PC1008", "SERVER14", "PC824", "SERVER12", "PC889", "PC843", "H07", "H08", "PC1009", "IBANKING", "MYOB2", "MYOB", "H10", "RDSAPP01", "HOMART-L102", "HOMART-EA", "SERVER24", "HOMART-JY-SPRO7", "H09", "PC852", "PC825", "H04", "HOMART_GM_LAPTO", "SERVER13A", "RDS04", "RDS05", "HOMART-L103", "PC842", "HOMART-L105", "RDSAPP02", "PC1007", "PC1002", "PC820", "TAB001", "TAB002", "TAB004", "H02", "TAB003", "PC7008", "H06", "H11", "H12", "PC822", "PC850", "HOMART-GM", "PC872", "PC203", "SERVER25", "PC896", "PC897", "HOMART-L104", "PC839", "HOMART-L107", "PC867", "HOMART-L101", "RDSAPP03", "H05", "HOMART-L109", "PC1013", "PC876", "HOMART_GM2", "H16", "HOMART-L108", "HOMART-L111", "HOMART-L112", "H14-UPJOHN1", "H15-UPJOHN2", "PC878", "PC7002", "JYPC", "PC883", "H17", "PC827", "MYOB3", "HOMART-L114", "PC863", "HOMART-L106", "PC877", "SAP02", "RDS01", "H19", "RDS06", "PC1015", "PC1016", "PC-898", "RDS02", "CLOCKONAPP", "RDS08", "HOMART-L115", "H18", "RDS07", "HOMART-L113", "PC7005", "RDS09", "HOMART-L116", "F01A")


# $jobs = @()

# foreach ($remoteComputer in $PCName) {
#     $job = @{
#         Name = $remoteComputer
#         ScriptBlock = {
#             param (
#                 $remoteComputer,
#                 $credentials
#             )
            
#             $pingResult = Test-Connection -ComputerName $remoteComputer -Count 4 -Quiet -ErrorAction SilentlyContinue

#             if ($pingResult) {
#                 try {
#                     # Collecting computer specifications
#                     $OS = Get-WmiObject -Class Win32_OperatingSystem -ComputerName $remoteComputer -Credential $credentials | Select-Object -ExpandProperty Caption
#                     $CPU = Get-WmiObject -Class Win32_Processor -ComputerName $remoteComputer -Credential $credentials | Select-Object -ExpandProperty Name
#                     $RAM = [math]::Round((Get-WmiObject -Class Win32_ComputerSystem -ComputerName $remoteComputer -Credential $credentials | Select-Object -ExpandProperty TotalPhysicalMemory) / 1GB, 2)
#                     $Disks = Get-WmiObject -Class Win32_DiskDrive -ComputerName $remoteComputer -Credential $credentials | ForEach-Object { $_.Size/1GB -as [int] }
#                     $DiskType = if ($_.MediaType -eq "Fixed hard disk media") { "HDD" } else { "SSD" }

#                     $output = [PSCustomObject]@{
#                         ComputerName = $remoteComputer
#                         OS           = $OS
#                         CPU          = $CPU
#                         RAM_GB       = $RAM
#                         Disk_GB      = $Disks -join ", "
#                         Disk_Type    = $DiskType
#                     }

#                     return $output
#                 } catch {
#                     Write-Error "Error collecting information for $remoteComputer. Error details: $($_.Exception.Message)"
#                 }
#             }
#         }
#         ArgumentList = $remoteComputer, $credentials
#     }
    
#     $jobs += Start-Job @job
# }

# $jobs | Wait-Job

# $OutputArray = $jobs | ForEach-Object { Receive-Job -Job $_ }

# $jobs | Remove-Job

# $outputFilePath = "D:\PowerShell_Script\Output\ComputerInfo.csv"

# $OutputArray | Export-Csv -Path $outputFilePath -NoTypeInformation

# # Outputting the path to the CSV file
# $outputFilePath


# $pcs = @("AD01", "RDSIS", "F01", "PC894", "RDS03", "PC832", "AD02", "PC851", "PC1003", "PC888", "PC1005", "PC892", "PC812", "PC841", "PC836", "PC875", "PC871", "SERVER10", "PC837", "PC848", "PC823", "PC844", "PC868", "PC847", "PC846", "PC833", "PC866A", "PC830", "PC845", "PC1014", "PC834", "PC874", "PC849", "PC873", "PC860", "PC886", "PC1012", "PC831", "PC861", "PC890", "SERVER17", "PC828", "PC835", "PC7004", "PC870", "PC1006", "PC862", "PC208", "PC891", "PC1010", "PC826", "PC865", "PC887", "PC880", "PC838", "PC885", "PC882", "PC881", "PC7009", "PC829", "PC1008", "SERVER14", "PC824", "SERVER12", "PC889", "PC843", "H07", "H08", "PC1009", "IBANKING", "MYOB2", "MYOB", "H10", "RDSAPP01", "HOMART-L102", "HOMART-EA", "SERVER24", "HOMART-JY-SPRO7", "H09", "PC852", "PC825", "H04", "HOMART_GM_LAPTO", "SERVER13A", "RDS04", "RDS05", "HOMART-L103", "PC842", "HOMART-L105", "RDSAPP02", "PC1007", "PC1002", "PC820", "TAB001", "TAB002", "TAB004", "H02", "TAB003", "PC7008", "H06", "H11", "H12", "PC822", "PC850", "HOMART-GM", "PC872", "PC203", "SERVER25", "PC896", "PC897", "HOMART-L104", "PC839", "HOMART-L107", "PC867", "HOMART-L101", "RDSAPP03", "H05", "HOMART-L109", "PC1013", "PC876", "HOMART_GM2", "H16", "HOMART-L108", "HOMART-L111", "HOMART-L112", "H14-UPJOHN1", "H15-UPJOHN2", "PC878", "PC7002", "JYPC", "PC883", "H17", "PC827", "MYOB3", "HOMART-L114", "PC863", "HOMART-L106", "PC877", "SAP02", "RDS01", "H19", "RDS06", "PC1015", "PC1016", "PC-898", "RDS02", "CLOCKONAPP", "RDS08", "HOMART-L115", "H18", "RDS07", "HOMART-L113", "PC7005", "RDS09", "HOMART-L116", "F01A")


# Define the PCs

# Define the servers

# $pcs = @("AD01", "RDSIS", "F01")
# # Define the credentials
# $username = "hpadmin3"
# $password = ConvertTo-SecureString "Mine@Zoom65" -AsPlainText -Force
# $credential = New-Object System.Management.Automation.PSCredential($username, $password)

# # Run the commands on each server in parallel
# $results = $pcs | ForEach-Object -Parallel {
#     Write-Host "Gathering information for $_"

#     # Use Invoke-Command with the -Credential parameter
#     $info = Invoke-Command -ComputerName $_ -Credential $using:credential -ScriptBlock {
#         # Get the information
#         $hostname = hostname
#         $model = (Get-WmiObject -Class Win32_ComputerSystem).Model
        
#         # Updated CPU Information Processing
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
#             Model = $model
#             CPUs = $cpus
#             RAMGB = $totalRam
#             RAMSlots = $ramSlots
#             RAMSpeedMHz = $ramSpeed
#             Disks = $disks
#         }

#         return $customObject
#     }

#     Write-Host "Information gathered for $_"
#     return $info
# }

# # Export the results to a CSV file
# $results | Export-Csv -Path 'D:\Powershell_Script\Output\ComputerInfo.csv' -NoTypeInformation

# Write-Host "Results exported to D:\Powershell_Script\Output\ComputerInfo.csv"

# # Prevent window from closing
# Read-Host -Prompt "Press Enter to exit"





# $pcs = @("AD01", "RDSIS", "F01", "PC894", "RDS03", "PC832", "AD02", "PC851", "PC1003", "PC888", "PC1005", "PC892", "PC812", "PC841", "PC836", "PC875", "PC871", "SERVER10", "PC837", "PC848", "PC823", "PC844", "PC868", "PC847", "PC846", "PC833", "PC866A", "PC830", "PC845", "PC1014", "PC834", "PC874", "PC849", "PC873", "PC860", "PC886", "PC1012", "PC831", "PC861", "PC890", "SERVER17", "PC828", "PC835", "PC7004", "PC870", "PC1006", "PC862", "PC208", "PC891", "PC1010", "PC826", "PC865", "PC887", "PC880", "PC838", "PC885", "PC882", "PC881", "PC7009", "PC829", "PC1008", "SERVER14", "PC824", "SERVER12", "PC889", "PC843", "H07", "H08", "PC1009", "IBANKING", "MYOB2", "MYOB", "H10", "RDSAPP01", "HOMART-L102", "HOMART-EA", "SERVER24", "HOMART-JY-SPRO7", "H09", "PC852", "PC825", "H04", "HOMART_GM_LAPTO", "SERVER13A", "RDS04", "RDS05", "HOMART-L103", "PC842", "HOMART-L105", "RDSAPP02", "PC1007", "PC1002", "PC820", "TAB001", "TAB002", "TAB004", "H02", "TAB003", "PC7008", "H06", "H11", "H12", "PC822", "PC850", "HOMART-GM", "PC872", "PC203", "SERVER25", "PC896", "PC897", "HOMART-L104", "PC839", "HOMART-L107", "PC867", "HOMART-L101", "RDSAPP03", "H05", "HOMART-L109", "PC1013", "PC876", "HOMART_GM2", "H16", "HOMART-L108", "HOMART-L111", "HOMART-L112", "H14-UPJOHN1", "H15-UPJOHN2", "PC878", "PC7002", "JYPC", "PC883", "H17", "PC827", "MYOB3", "HOMART-L114", "PC863", "HOMART-L106", "PC877", "SAP02", "RDS01", "H19", "RDS06", "PC1015", "PC1016", "PC-898", "RDS02", "CLOCKONAPP", "RDS08", "HOMART-L115", "H18", "RDS07", "HOMART-L113", "PC7005", "RDS09", "HOMART-L116", "F01A")



$pcs = @("PC894", "PC832", "PC851", "PC1003", "PC888", "PC1005", "PC892", "PC812", "PC841", "PC836", "PC875", "PC871", "PC837", "PC848", "PC823", "PC844", "PC868", "PC847", "PC846", "PC833", "PC866A", "PC830", "PC845", "PC1014", "PC834", "PC874", "PC849", "PC873", "PC860", "PC886", "PC1012", "PC831", "PC861", "PC890", "PC828", "PC835", "PC7004", "PC870", "PC1006", "PC862", "PC208", "PC891", "PC1010", "PC826", "PC865", "PC887", "PC880", "PC838", "PC885", "PC882", "PC881", "PC7009", "PC829", "PC1008", "PC824", "PC889", "PC843", "PC1009", "PC852", "PC825", "PC842", "PC1007", "PC1002", "PC820", "PC7008", "PC822", "PC850", "PC872", "PC203", "PC896", "PC897", "PC839", "PC867", "PC1013", "PC876", "PC878", "PC7002", "PC883", "PC827", "PC863", "PC877", "PC1015", "PC1016", "PC-898", "PC7005")
# $username = "hpadmin3"
# $password = ConvertTo-SecureString "Mine@Zoom65" -AsPlainText -Force
# $credential = New-Object System.Management.Automation.PSCredential($username, $password)

# $results = $pcs | ForEach-Object -Parallel {
#     Write-Host "Gathering information for $_"

#     $info = Invoke-Command -ComputerName $_ -Credential $using:credential -ScriptBlock {
#         $hostname = hostname
#         $model = (Get-WmiObject -Class Win32_ComputerSystem).Model

#         $cpuInfo = Get-WmiObject -Class Win32_Processor
#         $uniqueCpuInfo = $cpuInfo | Select-Object -Unique -Property Name, NumberOfCores, NumberOfLogicalProcessors, MaxClockSpeed
#         $cpuCount = $cpuInfo.Count
#         if ($uniqueCpuInfo.Count -gt 0) {
#             $cpuCount = $cpuCount / $uniqueCpuInfo.Count
#         }
#         $cpus = "$cpuCount * $($uniqueCpuInfo.Name)`n$($uniqueCpuInfo.NumberOfCores) Cores`n$($uniqueCpuInfo.NumberOfLogicalProcessors) Threads`n$($uniqueCpuInfo.MaxClockSpeed) MHz"

#         $totalRam = [math]::Round((Get-WmiObject -Class Win32_ComputerSystem).TotalPhysicalMemory / 1GB)
#         $ramSpeed = (Get-WmiObject -Class Win32_PhysicalMemory | Select-Object -First 1).Speed
#         $totalSlots = (Get-WmiObject -Class Win32_PhysicalMemoryArray).MemoryDevices
#         $usedSlots = (Get-WmiObject -Class Win32_PhysicalMemory).Count
#         $ramSlots = "$usedSlots/$totalSlots slots"

#         # Get disk information including type (HDD or SSD)
#         $disks = Get-WmiObject -Class Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 } | ForEach-Object {
#             # Get corresponding physical disk info for the logical disk
#             $physicalDisk = Get-WmiObject Win32_DiskDrive | Where-Object { $_.DeviceID.replace("\\\\.\\","") -eq $_.DeviceID }
#             # Determine disk type (HDD or SSD)
#             if ($physicalDisk.MediaType -like "*SSD*") {
#                 $diskType = "SSD"
#             } else {
#                 $diskType = "HDD"
#             }
#             "DeviceID: $($_.DeviceID)`nSize: $([math]::Round($_.Size / 1GB)) GB`nFree Space: $([math]::Round($_.FreeSpace / 1GB)) GB`nDisk Type: $($diskType)"
#         }
#         $disks = $disks -join "`n`n"

#         # Create a custom object with the information
#         [PSCustomObject]@{
#             Hostname     = $hostname
#             Model        = $model
#             CPUs         = $cpus
#             RAMGB        = "$totalRam GB"
#             RAMSlots     = "$ramSlots slots"
#             RAMSpeedMHz  = "$ramSpeed MHz"
#             Disks        = "$disks"
#         }
#     }

#     Write-Host "Information gathered for $_"
#     return $info
# } - ThrottleLimit 50

# $results | Export-Csv -Path 'D:\Powershell_Script\Output\ComputerInfo.csv' -NoTypeInformation

# Write-Host "Results exported to D:\Powershell_Script\Output\ComputerInfo.csv"

# Read-Host -Prompt "Press Enter to exit"




$pcs = @("PC894", "PC832", "PC851", "PC1003", "PC888", "PC1005", "PC892", "PC812", "PC841", "PC836", "PC875", "PC871", "PC837", "PC848", "PC823", "PC844", "PC868", "PC847", "PC846", "PC833", "PC866A", "PC830", "PC845", "PC1014", "PC834", "PC874", "PC849", "PC873", "PC860", "PC886", "PC1012", "PC831", "PC861", "PC890", "PC828", "PC835", "PC7004", "PC870", "PC1006", "PC862", "PC208", "PC891", "PC1010", "PC826", "PC865", "PC887", "PC880", "PC838", "PC885", "PC882", "PC881", "PC7009", "PC829", "PC1008", "PC824", "PC889", "PC843", "PC1009", "PC852", "PC825", "PC842", "PC1007", "PC1002", "PC820", "PC7008", "PC822", "PC850", "PC872", "PC203", "PC896", "PC897", "PC839", "PC867", "PC1013", "PC876", "PC878", "PC7002", "PC883", "PC827", "PC863", "PC877", "PC1015", "PC1016", "PC-898", "PC7005")
$username = "hpadmin3"
$password = ConvertTo-SecureString "Mine@Zoom65" -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($username, $password)

$results = $pcs | ForEach-Object -Parallel {
    Write-Host "Gathering information for $_"

    $info = Invoke-Command -ComputerName $_ -Credential $using:credential -Authentication Kerberos -ScriptBlock {
        $hostname = hostname
        $model = (Get-WmiObject -Class Win32_ComputerSystem).Model

        $cpuInfo = Get-WmiObject -Class Win32_Processor
        $uniqueCpuInfo = $cpuInfo | Select-Object -Unique -Property Name, NumberOfCores, NumberOfLogicalProcessors, MaxClockSpeed
        $cpuCount = $cpuInfo.Count
        if ($uniqueCpuInfo.Count -gt 0) {
            $cpuCount = $cpuCount / $uniqueCpuInfo.Count
        }
        $cpus = "$cpuCount * $($uniqueCpuInfo.Name)`n$($uniqueCpuInfo.NumberOfCores) Cores`n$($uniqueCpuInfo.NumberOfLogicalProcessors) Threads`n$($uniqueCpuInfo.MaxClockSpeed) MHz"

        $totalRam = [math]::Round((Get-WmiObject -Class Win32_ComputerSystem).TotalPhysicalMemory / 1GB)
        $ramSpeed = (Get-WmiObject -Class Win32_PhysicalMemory | Select-Object -First 1).Speed
        $totalSlots = (Get-WmiObject -Class Win32_PhysicalMemoryArray).MemoryDevices
        $usedSlots = (Get-WmiObject -Class Win32_PhysicalMemory).Count
        $ramSlots = "$usedSlots/$totalSlots slots"

        # Get disk information including type (HDD or SSD)
        $disks = Get-WmiObject -Class Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 } | ForEach-Object {
            # Get corresponding physical disk info for the logical disk
            $physicalDisk = Get-WmiObject Win32_DiskDrive | Where-Object { $_.DeviceID.replace("\\\\.\\","") -eq $_.DeviceID }
            # Determine disk type (HDD or SSD)
            if ($physicalDisk.MediaType -like "*SSD*") {
                $diskType = "SSD"
            } else {
                $diskType = "HDD"
            }
            "DeviceID: $($_.DeviceID)`nSize: $([math]::Round($_.Size / 1GB)) GB`nFree Space: $([math]::Round($_.FreeSpace / 1GB)) GB`nDisk Type: $($diskType)"
        }
        $disks = $disks -join "`n`n"

        # Create a custom object with the information
        [PSCustomObject]@{
            Hostname     = $hostname
            Model        = $model
            CPUs         = $cpus
            RAMGB        = "$totalRam GB"
            RAMSlots     = "$ramSlots slots"
            RAMSpeedMHz  = "$ramSpeed MHz"
            Disks        = "$disks"
        }
    }

    Write-Host "Information gathered for $_"
    return $info
} -ThrottleLimit 50

# Output the results to the console
$results | Format-Table

$results | Export-Csv -Path 'D:\Powershell_Script\Output\ComputerInfo.csv' -NoTypeInformation

Write-Host "Results exported to D:\Powershell_Script\Output\ComputerInfo.csv"

Read-Host -Prompt "Press Enter to exit"
