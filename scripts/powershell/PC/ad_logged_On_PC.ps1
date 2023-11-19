# Import the Active Directory module
Import-Module ActiveDirectory

# Define credentials
$Username = "hpadmin3"
$Password = ConvertTo-SecureString "Mine@Zoom65" -AsPlainText -Force
$Credentials = New-Object System.Management.Automation.PSCredential($Username, $Password)

# Connect to the domain controller
$DomainController = "ad01"
Set-ADServerSettings -Server $DomainController

# Get the computer object name of the currently logged in user
$ComputerName = $env:COMPUTERNAME
$Computer = Get-ADComputer -Identity $ComputerName -Credential $Credentials

# Output the computer object name
Write-Output $Computer.Name
