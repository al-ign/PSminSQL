function Register-Assembly
{
<#
.Synopsis
   Load .NET assembly
.DESCRIPTION
   Load .NET assembly or assemblies
.EXAMPLE
   Register-Assembly

   Load any .dll in the current path
.EXAMPLE
   Register-Assembly -Path ./lib/nestandard99/kewllib.dll

   Load a dll from the explicit path
#>
    [CmdletBinding()]
    [Alias('Register-Assemblies')]
    Param
    (

    # Path to *.dll
    [Alias('AssemblyPath')] 
    $Path = $PWD
    
    )

    function loadassembly {
        param ($pathToDll)

            try {
                [System.Reflection.Assembly]::LoadFile($pathToDll)
                Write-Verbose ("Loaded assembly: {0}" -f $pathToDll)
                }
            catch {
                Write-Error $_
                }
        }

    
    try {
        $thisPath = Get-Item $Path -ErrorAction Stop

        if ($thisPath.PSIsContainer) {
            Get-ChildItem -Filter '*.dll' | % {
                loadassembly $_.FullName
                }
            }

        # this whould be triggered both for when PSIsContainer is false (ie this is a file) and when this property doesn't exists
        else {
            loadassembly $thisPath.FullName
            }

        }
    Catch {
        Write-Error $_
        }
    
}
