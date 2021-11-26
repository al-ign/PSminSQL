function Register-Assemblies {

param (
    #Path to *.dll
    $assemblyPath = $PSScriptRoot,
    
    [switch]$Verbose
    )
    
#this script will try to load any .dll assemblies in the Assemblies sub-folder

if ($Verbose) {
    'Searching in {0}' -f ($assemblyPath | Join-Path -ChildPath 'Assemblies') | Write-Verbose
    }

$assemblyPath | Join-Path -ChildPath 'Assemblies' | Get-ChildItem -Filter '*.dll' -Recurse | % {
    
    $obj = [pscustomobject]@{
            File = $_.fullname
            Loaded = $false
            Error = $null
            }
    try {
        $nope = [System.Reflection.Assembly]::LoadFile($obj.File)
        $obj.Loaded = $true
        }
    catch {
        $obj.Error = $Error[0].Exception.Message
        }
    finally {
        if ($Verbose) {
            if ($obj.Loaded) {
                'Module loaded succesfully:  {0}' -f $obj.file | Write-Verbose
                }
            else {
                'Loading module  {0} failed with error: {1}' -f $obj.file, $obj.Error | Write-Verbose
                }
            }
        }
    }

}