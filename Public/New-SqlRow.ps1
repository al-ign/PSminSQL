function New-SqlRow {
    [CmdletBinding()]
    [Alias('Insert-SqlRow')]
    Param (
        # Object to be inserted
        [Parameter(Mandatory=$true, 
                   ValueFromPipeline=$true,
                   
                   ValueFromRemainingArguments=$false, 
                   Position=0)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        $Object,

        # Database Name
        [String]
        $Database,

        # Table name to insert to
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [String]
        $Table
    )

    Begin {
        #TODO Multiple-table syntax ?

        #table_reference 
        if ($Database) {
            $table_reference = '{0}.{1}' -f $Database, $Table
            }
        else {
            $table_reference = '{0}' -f $Table
            }
        
        }

    End {
    <#
    $entryProperties = @( Get-Member -InputObject $Object -MemberType NoteProperty | Select-Object -ExpandProperty Name )
    
    if ($entryProperties.Count -eq 0) {
        $entryProperties = @( Get-Member -InputObject $Object -MemberType Property | Select-Object -ExpandProperty Name )
        }

    if ($entryProperties.Count -eq 0) {
        Write-Verbose -Message ('Could not get the object properties to convert to SQL statement')
        return
        }

 

    $out = [pscustomobject]@{
        names = ''
        values = ''
        }


    'Type: {0}' -f $Object.GetType().Name 
    #>

    if ($Object.GetType().Name -eq 'Hashtable') {
        
        <#
        $set_def = foreach ($key in $Object.Keys) {
            '{0}=''{1}''' -f $key, $Object[$key]
            }
        
        $set_def = $set_def -join ', '
        #>

        $str_Cols = $Object.psbase.Keys -join ', '
        
        # $str_Values = ($Object.psbase.Values | % { '''{0}''' -f $_} ) -join ', '
    
        $str_Values = foreach ($value in $Object.psbase.Values) {

            #NULL check
            if ($null -eq $value) {
                "NULL"
                }
            else {
                switch ($value.GetType().Name) {
                    'DBNull' {
                        'NULL'
                        }
                    #MariaDB SQLese
                    'datetime' {
                        "(STR_TO_DATE('{0}','%Y-%m-%d %T'))" -f (($value).ToString('u') -replace 'Z$')
                        }
                    default {
                        "'{0}'" -f ($value)
                        }

                    }
                }

            
            }
        $str_Values = $str_Values -join ', '
    <#
    'keys: {0}' -f  $Object.psbase.Keys
    'cols: {0}' -f  $str_Cols
    'values: {0}' -f  $str_Values
    #>

        }
        
    elseif ($Object.GetType().Name -eq 'String') {
        $insert_def = $Object
        }

    if ($insert_def) {
        # do nothing, insert statement is supplied in the string
        }
    else {
        $insert_def = '({0}) VALUES ({1})' -f $str_Cols, $str_Values
        }

    $sqlQuery = 'INSERT INTO {0} {1};' -f $table_reference, $insert_def
    
    <#
    if ($Database.Length -gt 0) {
        "INSERT INTO ``{0}``.``{1}`` ({2}) VALUES ({3});" -f $Database, $Table, $out.names, $out.values
        }
    else {
        "INSERT INTO ``{0}`` ({1}) VALUES ({2});" -f $Table, $out.names, $out.values
        }
    #>

    #return
    $sqlQuery
    }
}