Import-Module ImportExcel

## function to loop through inventory paths and import into an array for sorting and searching

function Find-Inventory {
    
    $dnames = @("differentiator1", "differentiator2", "differentiator3", "differentiator4", "differentiator5", "differentiator6", "differentiator7")
    for ($($i=0; $combined_inv = @()); $i -lt $dnames.Length; $i++){$target = Resolve-Path ("G:\example\path\{0}-Inventory*.xlsx" -f ($dnames[$i])); $combined_inv += Import-Excel $target}
  
    $hostcheck = $combined_inv -match $userinput

    write-output $hostcheck


}
$userinput = Read-Host "Server Name"

Find-Inventory
