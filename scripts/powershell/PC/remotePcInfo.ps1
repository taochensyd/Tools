# Define the server array
$serverArray = @("PC882.homart.local", "PC863.homart.local", "PC881.homart.local", "PC7009.homart.local", "PC864.homart.local", "PC1008.homart.local", "PC1007.homart.local", "PC1017.homart.local", "PC843.homart.local", "PC883.homart.local", "PC852.homart.local", "Homart_GM_Laptop_Dell.homart.local", "PC822.homart.local", "PC850.homart.local", "PC7005.homart.local", "PC877.homart.local", "PC1003.homart.local", "Homart_L116.homart.local", "PC888.homart.local", "PC1005.homart.local", "PC878.homart.local", "PC841.homart.local", "PC875.homart.local", "PC871.homart.local", "PC823.homart.local", "PC868.homart.local", "PC847.homart.local", "PC866A.homart.local", "PC830.homart.local", "PC1014.homart.local", "PC7002.homart.local", "PC874.homart.local", "PC831.homart.local", "PC861.homart.local", "PC890.homart.local", "PC828.homart.local", "PC870.homart.local", "PC1020.homart.local", "PC862.homart.local", "PC1015.homart.local", "PC1016.homart.local", "PC880.homart.local", "PC838.homart.local", "Homart_GM2.homart.local", "PC885.homart.local")
Write-Output "Server array defined."

# Define the credentials
$username = "homart\hpadmin3"
$password = ConvertTo-SecureString "Mine@Zoom65" -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential($username, $password)
Write-Output "Credentials defined."

# Create a new text file
$outputFile = "C:\\Users\\hpadmin3\\Desktop"
if (Test-Path $outputFile) {
    Remove-Item $outputFile
}
Write-Output "Created a new text file at $outputFile."

# Get the remote server CPU list, RAM list, and Disk details for only online computers
foreach ($server in $serverArray) {
    Add-Content $outputFile "`nServer: $server"
    Write-Output "Processing server: $server"
    
    # Get CPU information
    $cpu = Invoke-Command -ComputerName $server -Credential $cred -Authentication Credssp -ScriptBlock {
        Get-WmiObject -Class Win32_Processor | Select-Object -Property Name, Description, DeviceID, NumberOfCores, NumberOfLogicalProcessors, MaxClockSpeed
    }
    Add-Content $outputFile "`nCPU Information:"
    $cpu | Format-Table | Out-String | Add-Content $outputFile
    Write-Output "CPU information retrieved and written to file."

    # Get RAM information
    $ram = Invoke-Command -ComputerName $server -Credential $cred -Authentication Credssp -ScriptBlock {
        $ramInfo = Get-WmiObject -Class Win32_PhysicalMemory | Select-Object -Property DeviceLocator, Capacity, Speed
        $ramInfo | ForEach-Object {
            $_.Capacity = "{0} GB" -f [math]::Round($_.Capacity / 1GB, 2)
            $_.Speed = "{0} MHz" -f $_.Speed
        }
        $ramInfo
    }
    Add-Content $outputFile "`nRAM Information for $($server):"
    $ram | Format-Table | Out-String | Add-Content $outputFile
    Write-Output "RAM information retrieved and written to file."

    # Get total and used memory slots
    $totalSlots = Invoke-Command -ComputerName $server -Credential $cred -Authentication Credssp -ScriptBlock {
        (Get-WmiObject -Class Win32_PhysicalMemoryArray).MemoryDevices
    }
    $usedSlots = $ram.Count
    Add-Content $outputFile "`nMemory Slots Used for $($server): $usedSlots / $totalSlots"
    Write-Output "Memory slot information retrieved and written to file."

    # Get Disk details
    $disk = Invoke-Command -ComputerName $server -Credential $cred -Authentication Credssp -ScriptBlock {
        Get-WmiObject -Class Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 } | Select-Object -Property DeviceID, @{Name="Size(GB)";Expression={"{0:N2}" -f ($_.Size/1GB)}}, @{Name="FreeSpace(GB)";Expression={"{0:N2}" -f ($_.FreeSpace/1GB)}}
    }
    Add-Content $outputFile "`nDisk Information for $($server):"
    $disk | Format-Table | Out-String | Add-Content $outputFile
    Write-Output "Disk information retrieved and written to file."
}

Write-Output "All tasks completed. The script will not exit."
