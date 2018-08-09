#Test Connection to requested server before proceeding
Write-host 'Performing Connection Test to' $ServerName
$ConTested = Test-connection -Quiet -ComputerName $ServerName

If ($ConTested -eq $true){
Write-Host 'Connection to' $ServerName 'Successful'
}
Else {Write-Host 'Please check the connection to' $ServerName
exit}

##############################################################
#Checking status of HealthService service on requested server#
##############################################################

$TimeWaited = 0

$SrvcStatus = GSV -Name HealthService -ComputerName $ServerName | select -ExpandProperty Status

Write-Host 'System Center Management (HealthService) status:'
Write-Output $SrvcStatus

If ($SrvcStatus -eq 'Running'){
GSV -name healthservice -computername $ServerName | stop-service -Force
}

#If the status of HealthService is stopped, the below code will run to attempt to start the service
$SrvcStatus2 = $SrvcStatus

Do{

If ($SrvcStatus2 -eq 'Stopped'){
GSV -name healthservice -computername $ServerName | set-service -status Running
}
ElseIf($SrvcStatus2 -eq 'StartPending'){
Start-Sleep 30
$TimeWaited += 30
If($TimeWaited -contains 180){
Write-Host 'Service took to long to start. Please try again.'
break
}
Else{Continue}
}
$SrvcStatus2 = GSV -Name HealthService -ComputerName $ServerName | select -ExpandProperty Status
} Until ($SrvcStatus2 -eq 'Running')

#Re-checks the status of requested server

$dblchecked = GSV -Name HealthService -ComputerName $ServerName | select -ExpandProperty Status

If ($dblchecked -eq 'Running'){
Write-Host 'Service has been started'
exit
}
Else{ 
Write-Host 'Service did not start'

}
