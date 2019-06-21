<#

.Synopsis

#>

param(
    [Parameter(Mandatory = $True,
        ValueFromPipeline = $True,
        ValueFromPipelineByPropertyName = $True,
        HelpMessage = "The. Computer. Name.")]
    [Alias('Hostname', 'cn')]
    [string[]]$ComputerName
)

BEGIN {}
PROCESS {

    foreach ($Computer in $ComputerName) {
        try {
            $session = New-CimSession -ComputerName $Computer -ErrorAction Stop
            $os = Get-CimInstance -ClassName win32_operatingsystem -CimSession $session
            $cs = Get-CimInstance -ClassName win32_computersystem -CimSession $session
            $properties = @{ ComputerName = $Computer
                Status                    = 'Connected'
                SPVersion                 = $os.ServicePackMajorVersion
                OSVersion                 = $os.Version
                Model                     = $cs.model
                MfGr                      = $cs.Manufacturer  
            }
        }
        catch {
            #write-verbose "Couldn't connect to $Computer"
            write-Warning "Couldn't connect to $Computer"
            $properties = @{ ComputerName = $Computer
                Status                    = 'Disonnected'
                SPVersion                 = $null
                OSVersion                 = $null
                Model                     = $null
                MfGr                      = $null 
            }
        }
        finally {
            $obj = New-Object -TypeName PSObject -Property $properties
            Write-Output $obj        
        }
    }
}
END {}