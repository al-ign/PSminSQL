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

        # Database name
        [String]
        $Database,

        # Table name 
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [String]
        $Table,

        # Add RETURNING statement, use * to return all columns
        [String]
        $Returning
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

    if ($Object.GetType().Name -match 'Hashtable') {
        
        $str_Cols = $Object.psbase.Keys -join ', '
    
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

    $sqlQuery = 'INSERT INTO {0} {1}' -f $table_reference, $insert_def
    
    if ($Returning) {
        $sqlQuery = '{0} RETURNING {1}' -f $sqlQuery, $Returning
        }

    $sqlQuery = '{0};' -f $sqlQuery
    #return
    $sqlQuery
    }
}