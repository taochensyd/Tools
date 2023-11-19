# Import the Active Directory module
Import-Module ActiveDirectory

# Get the list of computer objects
$computerObjects = Get-ADComputer -Filter *

# Extract the Name property of each computer object and format it
$computerNames = $computerObjects | ForEach-Object { "`"$(($_.Name))`"" }

# Join the formatted names into a comma-separated string
$computerNamesString = $computerNames -join ", "

# Format the string as a PowerShell array definition
$pcNameArrayDefinition = "`$PCName = @($computerNamesString)"

# Output the array definition to a file
$pcNameArrayDefinition | Out-File -FilePath "C:\Powershell_Script\PCName.txt"
