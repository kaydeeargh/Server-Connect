################################
# Global Variables & Functions #
################################

    function DiskSpace{

        ## Gets freespace % and Formats a readable table
        Get-WmiObject Win32_logicaldisk -ComputerName $ServerName -Credential $cred -Filter $DeviceID`
        | Format-Table DeviceID, `
        @{Name="Size(GB)";Expression={[decimal]("{0:N2}" -f($_.size/1gb))}}, `
        @{Name="Free Space(GB)";Expression={[decimal]("{0:N2}" -f($_.freespace/1gb))}}, `
        @{Name="Free (%)";Expression={"{0,6:P1}" -f(($_.freespace/1gb) / ($_.size/1gb))}} `
        -AutoSize
    }



    function CleanUp{
        Write-Host 'Cleaning up the Drive!'
        $cleanmgr = Invoke-Command -Computername $ServerName -Credential $cred {C:\Windows\system32\cleanmgr.exe /sagerun:1}
        If($? -eq 'True'){
            Write-Host 'CleanMgr successful'
            Invoke-Command -Computername $ServerName -Credential $cred {Remove-Item C:\WINDOWS\SoftwareDistribution\* -recurse -ErrorAction SilentlyContinue}
            Get-WmiObject Win32_logicaldisk -ComputerName $ServerName  -Credential $cred -Filter $DeviceID` | Format-Table DeviceID, `
            @{Name="New Free Space(%)";Expression={"{0,6:P1}" -f(($_.freespace/1gb) / ($_.size/1gb))}} `
            -AutoSize

            ###Testing Waiting Indicator

            <#
            $origpos = $host.UI.RawUI.CursorPosition
            $origpos.Y += 1

            while (($job.State -eq "Running") -and ($job.State -ne "NotStarted"))
            {
	            $host.UI.RawUI.CursorPosition = $origpos
	            Write-Host $scroll[$idx] -NoNewline
	            $idx++
	            if ($idx -ge $scroll.Length)
	            {
		            $idx = 0
	            }
	            Start-Sleep -Milliseconds 100
            }
            # It's over - clear the activity indicator.
            $host.UI.RawUI.CursorPosition = $origpos
            Write-Host ' ' #>
            }
            
    }



#Test Connection to requested server before proceeding
Write-host 'Performing Connection Test to' $ServerName
$ConTested = Test-connection -Quiet -ComputerName $ServerName

If ($ConTested -eq $true){
Write-Host 'Connection to' $ServerName 'Successful'
}
Else {Write-Host 'Please check the connection to' $ServerName
exit}

$Drive = Read-Host -Prompt 'Which drive is low on disk space? Just the letter, please'
#Removes non-alphabet characters
$Pattern = '[^a-zA-Z]'
$Drive -replace $Pattern > $null
$DeviceID = "DeviceID='{0}{1}' " -f $Drive, ':'

If ($DeviceID -eq "DeviceID='C:' "){

DiskSpace

##Creates variables for objects in the command
$space = Get-WmiObject Win32_logicaldisk -ComputerName $ServerName -Credential $cred -Filter $DeviceID
foreach($item in $space > $null){
Write-Host $item.DeviceID $item.freespace $item.size}

If ((($space.freespace/1gb) / ($space.size/1gb)*100) -le 10){
    CleanUp 
}

Else 
{
Write-Host 'Free space is over 10%. You can close the ticket'
do
{
Write-Host 'Would you like to clean the drive anyways? Default is N. [Y\N]'
$confirm = Read-Host -Prompt ' '
$confirm -replace $Pattern > $null

if ($confirm -eq 'N'){
break 
}
ElseIf ($confirm -eq 'Y'){
CleanUp
break
}
Else {
Write-Host 'Try again. Clean Drive anyways? [Y\N}'
}
}
until ($confirm -eq 'N')


}
}

Else{

DiskSpace
Write-Host "Please assign to the server's owner or group to clean unnecessary logs and files"

}
