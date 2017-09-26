$SecSep = '--------------------------------'

##Variables
$successarray = @()
$failarray = @()
$report =  'C:\Users\kdd0921\Documents\BMC_Reports\Report.csv'

$a = Import-Csv $report | ForEach-Object {
if ($_.Notes -match 'Microsoft.SystemCenter.AgentWatchersGroup - The computer |  was not accessible.')
    {
    $_.Notes -replace 'Microsoft.SystemCenter.AgentWatchersGroup - The computer', '' -replace 'was not accessible.', ''

    }
}

$b = $null



write-output $a

$SecSep

foreach ($item in $a)
{
    $t = Test-Connection -Quiet -computername $item -ErrorAction SilentlyContinue -ErrorVariable ProcessError
    if ($t -eq $true)
    {
        Write-Output "$item Success!"
        $successarray += ,$item
    }
    else
    {
        $failarray += ,$item
    }
}

$SecSep