<# 
    .SYNOPSIS 
    Execute a non-query on a database
 
    .DESCRIPTION 
    Execute SQL queries using ADO.NET. 
 
    .PARAMETER Query 
    The SQL query to execute which could be any string containing simple valid SQL. Can consist of
    multiple SQL commands separated by semicolons which will be processed sequentially by the Cmdlet.
 
    .PARAMETER Provider 
    The ADO.NET dataprovider used for accessing the data source to query. Can be any of the following:
    Sql - Provides data access for Microsoft SQL Server
    OleDb - For data sources exposed by using OLE DB
    Odbc - For data sources exposed by using ODBC
    Oracle - For Oracle data sources
    Entity - Provides data access for Entity Data Model (EDM) applications
    SqlCe - Provides data access for Microsoft SQL Server Compact 4.0
 
    .PARAMETER ConnectionString 
    The database connection string.
	
    .OUTPUTS
    Amount of affected rows

    .NOTES
    Original work by https://github.com/off-world/PowerADO.NET/blob/master/PowerADO.NET.psm1
	
    .COMPONENT
    ADO.NET
 
    .EXAMPLE 
    $query = "INSERT INTO Customers VALUES ('Doe','John')" 
    $query | Invoke-SqlQuery -Provider Sql -ConnectionString 'Server=db1.contoso.com;Database=CustomersDb;User Id=Admin;Password=pwd' 
 
    .EXAMPLE 
    $query1 = "INSERT INTO Customers VALUES ('Doe','John')" 
    $query1 | query Sql 'Server=db1.contoso.com;Database=CustomersDb;User Id=Admin;Password=pwd' 
#>
function Invoke-SqlNonQuery {
    [CmdletBinding()]
    [Alias('Invoke-DotNetSqlNonQuery')]
    [OutputType([int])]
    param(
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [String]
        $Query,

        [Parameter(Mandatory=$true, Position=0)]
        [ValidateSet('MySql', 'Sql', 'OleDb', 'Odbc', 'Oracle', 'Entity', 'SqlCe')]
        [String]
        $Provider,

        [Parameter(Mandatory=$true, Position=1)]
        [String]
        $ConnectionString
    )

    begin
    {
        $sql = New-SQLConnector -Provider $Provider -ConnectionString $ConnectionString
        }

    process {
        ForEach ($thisQuery in $Query) {
            if (-not [String]::IsNullOrWhiteSpace($thisQuery)) {
                $sql.command.CommandText = $thisQuery.Trim()
                $sql.command.ExecuteNonQuery()
                }
            }
    }

    end
    {
        $sql.connection.Close()
    }
}
