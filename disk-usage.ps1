function Get-DiskUsage ([string]$path=".") {
    $groupedList = Get-ChildItem -Recurse -File $path -Depth 1 | Group-Object directoryName | Select-Object name,@{name='Size'; expression={($_.group | Measure-Object -sum length).sum / 1MB} }
    foreach ($dn in $groupedList) {
        New-Object psobject -Property @{ directoryName=$dn.name; Size=($groupedList | Where-Object { $_.name -like "$($dn.name)*" } | Measure-Object -Sum length).sum / 1MB }
    }
}
