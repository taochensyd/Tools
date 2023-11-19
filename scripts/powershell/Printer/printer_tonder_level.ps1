# Printer IP
$PrinterIP = "192.168.0.26"

# SNMP Community String
$Community = "homart"

# OIDs for Toner Levels
$BlackTonerOID = ".1.3.6.1.4.1.11.2.3.9.4.2.1.4.1.10.1.1.37.1.0"
$CyanTonerOID = ".1.3.6.1.4.1.11.2.3.9.4.2.1.4.1.10.1.1.37.2.0"
$MagentaTonerOID = ".1.3.6.1.4.1.11.2.3.9.4.2.1.4.1.10.1.1.37.3.0"
$YellowTonerOID = ".1.3.6.1.4.1.11.2.3.9.4.2.1.4.1.10..37..0"

# Function to get SNMP data
function Get-SNMPData {
    param($ip, $oid, $community)
    $snmp = New-Object -ComObject olePrn.OleSNMP
    $snmp.Open($ip, $community, 2, 2000)
    $result = $snmp.Get($oid)
    $snmp.Close()
    return $result
}

# Get Toner Levels
$BlackTonerLevel = Get-SNMPData -ip $PrinterIP -oid $BlackTonerOID -community $Community
$CyanTonerLevel = Get-SNMPData -ip $PrinterIP -oid $CyanTonerOID -community $Community
$MagentaTonerLevel = Get-SNMPData -ip $PrinterIP -oid $MagentaTonerOID -community $Community
$YellowTonerLevel = Get-SNMPData -ip $PrinterIP -oid $YellowTonerOID -community $Community

# Output
Write-Output "Black Toner Level: $BlackTonerLevel"
Write-Output "Cyan Toner Level: $CyanTonerLevel"
Write-Output "Magenta Toner Level: $MagentaTonerLevel"
Write-Output "Yellow Toner Level: $YellowTonerLevel"
