################################
# Global Variables & Functions #
################################

$SecSep = '--------------------------------'
$ServerName =
$OptionSelected =
$Spacing = Write-Host `n
$domain = 
$cred = $null

Do {

$user = "{0}\{1}" -f $env:USERDOMAIN, "sa-$env:USERNAME"

Write-Host '#########################################################' `n
Write-Host "Welcome to KDR's Script! What server are you working on?" `n
Write-Host '#########################################################' `n

Function Domain {
    $Global:cred = Get-Credential -Credential $user
    try{
        Get-WmiObject win32_computersystem -ComputerName $ServerName -cred $cred | Select -ExpandProperty "Domain" > $null;
    } catch {
        $Global:user = "{0}\{1}" -f "ReynoldsPKG", "sa-$env:USERNAME"
        $Global:cred = Get-Credential -Credential $user
    }
    $Global:domain = Get-WmiObject win32_computersystem -ComputerName $ServerName -Credential $cred | Select -ExpandProperty "Domain"
    Write-Host "Domain: $domain"
    $Spacing

}
Function SrvrName {
Write-Host 'Enter SERVER to get OPTIONS'
$SecSep
    Do {
        $Global:ServerName = (Read-Host -Prompt 'Server Name').ToUpper()                
    } Until (!($ServerName -eq ""))

}
Function OpSelect {
$Global:OptionSelected = Read-Host -Prompt 'Please select an option'

}

#-------------------#
# Options to Select #
#-------------------#

SrvrName
Domain
$Spacing
Write-Host 'Please select from the following options:' `n
$SecSep
Write-Host '1.Health Service Heartbeat Failure' `n
Write-Host '2.Failed to Connect to Computer' `n
Write-Host '3.Logical Disk Free Space is low' `n
Write-Host '4.SQL Cluster Status Check' `n
Write-Host '10. Exit and Close Console' `n
$SecSep
Write-Host `n
OpSelect

#-------------------#
# Calls to Scripts  #
#-------------------#
Set-ExecutionPolicy Bypass -Scope Process

If ($OptionSelected -eq 1){
cd "C:\PS_Scripts\Interactive Prompt Scripts"
& .\Healthservice.PS1
}

If ($OptionSelected -eq 3){
cd "C:\PS_Scripts\Interactive Prompt Scripts"
& .\LowDiskSpace.ps1
}

If ($OptionSelected -eq 4){
cd "C:\PS_Scripts\Interactive Prompt Scripts"
& .\GetClusterInfo.ps1
}



$SecSep

Pause

Clear-Host
} Until ($OptionSelected -eq 10)
Exit
