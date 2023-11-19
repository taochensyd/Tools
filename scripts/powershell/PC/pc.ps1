# $pcs = @("PC894", "PC832", "PC851", "PC1003", "PC888", "PC1005", "PC892", "PC812", "PC841", "PC836", "PC875", "PC871", "PC837", "PC848", "PC823", "PC844", "PC868", "PC847", "PC846", "PC833", "PC866A", "PC830", "PC845", "PC1014", "PC834", "PC874", "PC849", "PC873", "PC860", "PC886", "PC1012", "PC831", "PC861", "PC890", "PC828", "PC835", "PC7004", "PC870", "PC1006", "PC862", "PC208", "PC891", "PC1010", "PC826", "PC865", "PC887", "PC880", "PC838", "PC885", "PC882", "PC881", "PC7009", "PC829", "PC1008", "PC824", "PC889", "PC843", "PC1009", "PC852", "PC825", "PC842", "PC1007", "PC1002", "PC820", "PC7008", "PC822", "PC850", "PC872", "PC203", "PC896", "PC897", "PC839", "PC867", "PC1013", "PC876", "PC878", "PC7002", "PC883", "PC827", "PC863", "PC877", "PC1015", "PC1016", "PC-898", "PC7005")
# $pcs = @("PC851", "PC1003", "PC888", "PC1005", "PC892", "PC812", "PC841", "PC836", "PC875", "PC871")



# # Define the array
# $pcs = @("PC894", "PC888")

# # Define the array
# $pcs = @("PC894", "PC832", "PC851", "PC1003", "PC888", "PC1005", "PC892", "PC812", "PC841", "PC836", "PC875", "PC871")

# # Specify the username and password
# $username = "hpadmin3"
# $password = ConvertTo-SecureString "Mine@Zoom65" -AsPlainText -Force
# $credential = New-Object System.Management.Automation.PSCredential($username, $password)

# # Loop through each computer in the list
# foreach ($Computer in $pcs) {
#     # Get WMI objects
#     $cs = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $Computer -Credential $credential
#     $cpu = Get-WmiObject -Class Win32_Processor -ComputerName $Computer -Credential $credential
#     $ip = (Get-WmiObject -Class Win32_NetworkAdapterConfiguration -ComputerName $Computer -Credential $credential | Where-Object { $_.IPAddress }).IPAddress

#     # Create a custom object with the information
#     $info = New-Object PSObject -Property @{
#         ComputerName     = $Computer
#         CPUName          = $cpu.Name
#         InstalledRAMGB   = [math]::Round($cs.TotalPhysicalMemory / 1GB, 2)
#         IPAddress        = $ip -join ', '
#     }

#     # Output the information
#     $info | Format-Table -AutoSize
# }
# Define the array
$pcs = @("PC894", "PC888")  # Replace with your actual PC names

# Specify the username and password
$username = "hpadmin3"  # Replace with your actual username
$password = ConvertTo-SecureString "Mine@Zoom65" -AsPlainText -Force  # Replace with your actual password
$credential = New-Object System.Management.Automation.PSCredential($username, $password)

# Loop through each computer in the list
foreach ($Computer in $pcs) {
    # Run qwinsta command
    $sessionInfo = Invoke-Command -ComputerName $Computer -Credential $credential -ScriptBlock {
        & qwinsta
    }

    # Output the session information
    Write-Host "Session information for $Computer:"
    Write-Host $sessionInfo
}
