function Set-SqlRow {
    [CmdletBinding()]
    [Alias('Update-SqlRow')]
    Param (
        # Object to be inserted
        [Parameter(Mandatory=$true, 
                   ValueFromPipeline=$true,
                   
                   ValueFromRemainingArguments=$false, 
                   Position=0)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        $Object,

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

        #TODO Multiple-table syntax ?

        #table_reference 
        if ($Database) {
            $table_reference = '{0}.{1}' -f $Database, $Table
            }
        else {
            $table_reference = '{0}' -f $Table
            }
        }

    Process {

        #parse object to set_def depending on the object type
        
        if ($Object.GetType().Name -eq 'Hashtable') {
        
            $set_def = foreach ($key in $Object.psbase.Keys) {
                '{0}=''{1}''' -f $key, $Object[$key]
                }
        
            $set_def = $set_def -join ', '
            }
        
        elseif ($Object.GetType().Name -eq 'String') {
            $set_def = $Object
            }

        $sqlQuery = 'UPDATE {0} SET {1}' -f $table_reference, $set_def
        
        if ($Where) {
            $sqlQuery = '{0} WHERE {1}' -f $sqlQuery, $Where
            }

        if ($OrderBy) {
            $sqlQuery = '{0} ORDER BY {1}' -f $sqlQuery, $OrderBy
            }

        if ($Limit) {
            $sqlQuery = '{0} LIMIT {1}' -f $sqlQuery, $Limit
            }

        #return
        $sqlQuery
        
        }
    }
