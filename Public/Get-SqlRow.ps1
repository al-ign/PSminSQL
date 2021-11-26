function Get-SqlRow {
    [CmdletBinding()]
    #[Alias('')]
    Param (
        # Object to be inserted
        [Parameter(Mandatory=$true, 
                   ValueFromPipeline=$true,
                   
                   ValueFromRemainingArguments=$false, 
                   Position=0)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string[]]$Columns,

        [String]
        $Where,

        [String]
        $OrderBy,

        [int]
        $Limit,

        # Database Name
        [String]
        $Database,

        # Table name to insert to
        [Parameter(Mandatory=$true, 
                ValueFromPipeline=$true
                )]

        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [String]
        $Table
    )

    Begin {
        #table_reference 
        if ($Database) {
            $table_reference = '{0}.{1}' -f $Database, $Table
            }
        else {
            $table_reference = '{0}' -f $Table
            }
        }

    End {    
        $sqlQuery = 'SELECT {0} FROM {1}' -f ($Columns -join ', '), $table_reference

        if ($Where) {
            $sqlQuery = '{0} WHERE {1}' -f $sqlQuery, $Where
            }

        if ($OrderBy) {
            $sqlQuery = '{0} ORDER BY {1}' -f $sqlQuery, $OrderBy
            }

        if ($Limit) {
            $sqlQuery = '{0} LIMIT {1}' -f $sqlQuery, $Limit
            }

        $sqlQuery
        }

}
