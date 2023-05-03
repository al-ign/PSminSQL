<#
.Synopsis
   Creates an instance of SQL connector

.DESCRIPTION
   Creates an instance of SQL connector

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
    A hashtable with Connection and Command items.

.EXAMPLE
   $sql = New-SQLConnector -Provider MySql -ConnectionString 'server=localhost;username=root;password=root'

.EXAMPLE
   $sql = New-SQLConnector -Provider MySql -ConnectionString 'server=localhost;username=root;password=root'
   $sql.command.CommandText = 'UPDATE database01.mac SET lastseen='2021-11-24 03:58:43' WHERE ID = 11543"
   $sql.command.ExecuteNonQuery() 
#>
function New-SQLConnector {
    [CmdletBinding()]
    [Alias('New-DotNetSqlConnector')]
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [ValidateSet('MySqlConnector', 'MySql', 'Sql', 'OleDb', 'Odbc', 'Oracle', 'Entity', 'SqlCe')]
        [String]
        $Provider,

        [Parameter(Mandatory=$true, Position=1)]
        [String]
        $ConnectionString
        )

        try {

            $connection, $command = switch ($Provider)
                {
                    'MySqlConnector'
                    {
                        [MySqlConnector.MySqlConnection]::new($ConnectionString)
                        [MySqlConnector.mysqlcommand]::new()
                    }
                    'MySql'
                    {
                        [MySql.Data.MySqlClient.MySqlConnection]::new($ConnectionString)
                        [mysql.data.mysqlclient.mysqlcommand]::new()
                    }
                    'Sql'
                    {
                        [System.Data.SqlClient.SqlConnection]::new($ConnectionString)
                        [System.Data.SqlClient.SqlCommand]::new()
                    }
                    'OleDb'
                    {
                        [System.Data.OleDb.OleDbConnection]::new($ConnectionString)
                        [System.Data.OleDb.OleDbCommand]::new()
                    }
                    'Odbc'
                    {
                        [System.Data.Odbc.OdbcConnection]::new($ConnectionString)
                        [System.Data.Odbc.OdbcCommand]::new()
                    }
                    'Oracle'
                    {
                        [System.Data.OracleClient.OracleConnection]::new($ConnectionString)
                        [System.Data.OracleClient.OracleCommand]::new()
                    }
                    'Entity'
                    {
                        [System.Data.EntityClient.EntityConnection]::new($ConnectionString)
                        [System.Data.EntityClient.EntityCommand]::new()
                    }
                    'SqlCe'
                    {
                        [System.Data.SqlServerCe.SqlCeConnection]::new($ConnectionString)
                        [System.Data.SqlServerCe.SqlCeCommand]::new()
                    }
                }

            $connection.Open()
            $command.Connection = $connection
            }
        catch {
            Write-Error $_
            break
            }

    @{
        Connection = $connection
        Command = $command
        }
}