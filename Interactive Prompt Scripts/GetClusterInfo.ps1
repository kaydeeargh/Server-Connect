﻿
Invoke-Command -computername $ServerName -cred $cred -Scriptblock {

import-module Failoverclusters

get-cluster | Format-Table
get-clusternetwork | Format-Table
get-clusternode | Format-Table -Property NodeName, State

Write-Host 'Cluster Group:'
get-clustergroup | Format-Table
}

