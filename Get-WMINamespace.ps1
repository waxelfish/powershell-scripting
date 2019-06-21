Function Get-WmiNamespace {
    Param (
        $Namespace='root'
    )
    Get-WmiObject -Namespace $Namespace -Class __NAMESPACE | ForEach-Object {
            ($ns = '{0}\{1}' -f $_.__NAMESPACE,$_.Name)
            Get-WmiNamespace $ns
    }
}

Get-WmiNamespace
