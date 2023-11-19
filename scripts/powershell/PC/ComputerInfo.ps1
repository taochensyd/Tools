# Prompt for credentials
$credential = Get-Credential

# Define the hostnames
$hostnames = @("AD01", "RDSIS", "F01", "PC894", "RDS03", "PC832", "AD02", "PC851", "PC1003", "PC888", "PC1005", "PC892", "PC812", "PC841", "PC836", "PC875", "PC871", "SERVER10", "PC837", "PC848", "PC823", "PC844", "PC868", "PC847", "PC846", "PC833", "PC866A", "PC830", "PC845", "PC1014", "PC834", "PC874", "PC849", "PC873", "PC860", "PC886", "PC1012", "PC831", "PC861", "PC890", "SERVER17", "PC828", "PC835", "PC7004", "PC870", "PC1006", "PC862", "PC208", "PC891", "PC1010", "PC826", "PC865", "PC887", "PC880", "PC838", "PC885", "PC882", "PC881", "PC7009", "PC829", "PC1008", "SERVER14", "PC824", "SERVER12", "PC889", "PC843", "H07", "H08", "PC1009", "IBANKING", "MYOB2", "MYOB", "H10", "RDSAPP01", "HOMART-L102", "HOMART-EA", "SERVER24", "HOMART-JY-SPRO7", "H09", "PC852", "PC825", "H04", "HOMART_GM_LAPTO", "SERVER13A", "RDS04", "RDS05", "HOMART-L103", "PC842", "HOMART-L105", "RDSAPP02", "PC1007", "PC1002", "PC820", "TAB001", "TAB002", "TAB004", "H02", "TAB003", "PC7008", "H06", "H11", "H12", "PC822", "PC850", "HOMART-GM", "PC872", "PC203", "SERVER25", "PC896", "PC897", "HOMART-L104", "PC839", "HOMART-L107", "PC867", "HOMART-L101", "RDSAPP03", "H05", "HOMART-L109", "PC1013", "PC876", "HOMART_GM2", "H16", "HOMART-L108", "HOMART-L111", "HOMART-L112", "H14-UPJOHN1", "H15-UPJOHN2", "PC878", "PC7002", "JYPC", "PC883", "H17", "PC827", "MYOB3", "HOMART-L114", "PC863", "HOMART-L106", "PC877", "SAP02", "RDS01", "H19", "RDS06", "PC1015", "PC1016", "PC-898", "RDS02", "CLOCKONAPP", "RDS08", "HOMART-L115", "H18", "RDS07", "HOMART-L113", "PC7005", "RDS09", "HOMART-L116", "F01A")
# $hostnames = @("AD01", "RDSIS", "F01", "PC894", "RDS03")
# Create an empty array to store the jobs
$jobs = @()

# Loop through each hostname
foreach ($hostname in $hostnames) {
    # Get all computer info in parallel
    $job = Start-Job -ScriptBlock { param($hostname, $credential) Invoke-Command -ComputerName $hostname -Credential $credential -ScriptBlock { Get-ComputerInfo } } -ArgumentList $hostname, $credential
    # Add the job to the jobs array
    $jobs += $job
}

# Wait for all jobs to complete or timeout after 10 seconds
foreach ($job in $jobs) {
    if ($job | Wait-Job -Timeout 10) {
        # Collect the results from each job
        $results = Receive-Job -Job $job
        Write-Output "Received info from $($job.Name)"
    } else {
        Write-Output "Job $($job.Name) did not respond in time"
    }
}

# Export the results to a CSV file (which can be opened with Excel)
$results | Export-Csv -Path "D:\Powershell_Script\Output\computer_info.csv" -NoTypeInformation

# Clean up the jobs
$jobs | Remove-Job
