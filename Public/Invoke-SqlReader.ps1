<#
.Synopsis
   Execute SQL reader
.DESCRIPTION
   Execute .NET SQL reader method on SQL Command object to retrieve all rows
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>

function Invoke-SqlReader {
    [CmdletBinding()]
    [Alias('Invoke-DotNetSqlReader')]
    Param
    (
        # SQL Command object
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   Position=0)]
        $Command
    )

    try {
        $reader = $Command.ExecuteReader()
        while ($reader.Read())
            {
            $row = [ordered]@{}
            for ($i=0; $i -lt $reader.FieldCount; $i++)  {
                $row.Add($reader.GetName($i) , $reader[$i])
                }
            [pscustomobject]$row
                        
            }
            $reader.Close()
        }
    catch {
        Write-Error $_
        }
}