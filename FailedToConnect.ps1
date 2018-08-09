$SecSep = '--------------------------------'

##Variables
$successarray = @()
$failarray = @()
$report =  'C:\Users\Username\Documents\BMC_Reports\Report.csv'
$a = Import-Csv $report


$a | ForEach-Object {
    if ($_.Notes -match 'Microsoft.SystemCenter.AgentWatchersGroup - The computer |  was not accessible.'){  
        $b = $_.Notes -replace 'Microsoft.SystemCenter.AgentWatchersGroup - The computer', '' -replace 'was not accessible.', ''
        $c = $b -replace '\s','' #removes any random spaces from string

        #create new object with incID and computername together in a single object
        $incident = New-Object System.Object
        $incident | Add-Member -type NoteProperty -name IncidentID -Value $_.'Incident ID*+'
        $incident | Add-Member -type NoteProperty -name ComputerName -Value $c

        #test connection
        if (test-connection $c -count 1 -quiet){
            $successarray += $incident
        }else {$failarray += $incident}
    }
}

$SecSep

##Output list of successful objects to the console
Write-Output "Successful Connection Attempts:"
Write-Output $successarray
Write-Output `n

$SecSep

##Output list of failed objects to the console
Write-Output "Failed Connection Attempts:"
write-output `n
Write-Output $failarray


$SecSep
