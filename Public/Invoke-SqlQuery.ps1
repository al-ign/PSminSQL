﻿<# 
    .SYNOPSIS 
    Query a database. 
 
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
    On SELECT commands, matching rows will be returned from the database as PowerShell objects.
    Other commands like INSERT or DELETE are executed without any return value. The amount
    of rows in the database affected by those commands will be shown when the -Verbose switch
    is specified, though.

    .NOTES
    Original work by https://github.com/off-world/PowerADO.NET/blob/master/PowerADO.NET.psm1
	
    .COMPONENT
    ADO.NET
 
    .EXAMPLE 
    'SELECT * FROM Customers' | Invoke-SqlQuery -Provider OleDb -ConnectionString 'Provider=Microsoft.ACE.OLEDB.12.0;Data Source=.\db1.accdb' 
 
    .EXAMPLE 
    $query = "INSERT INTO Customers VALUES ('Doe','John');SELECT * FROM Customers WHERE Surname='John'" 
    $query | Invoke-SqlQuery -Provider Sql -ConnectionString 'Server=db1.contoso.com;Database=CustomersDb;User Id=Admin;Password=pwd' 
 
    .EXAMPLE 
    $query1 = "INSERT INTO Customers VALUES ('Doe','John')" 
    $query2 = "SELECT * FROM Customers WHERE Surname='John'" 
    $query1, query2 | query Sql 'Server=db1.contoso.com;Database=CustomersDb;User Id=Admin;Password=pwd' 
#>
function Invoke-SqlQuery
{
    [CmdletBinding()]
    [Alias('Invoke-DotNetSqlQuery')]

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

    process
    {
        ForEach ($thisQuery in $Query) {

            $sql.command.CommandText = $thisQuery.Trim()
                
            if ($sql.command.CommandText -match '^\s*(SELECT )|(SHOW )')
            {
                
                Invoke-SqlReader -Command $sql.Command

                <#
                try {
                    $reader = $sql.command.ExecuteReader()
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
                    #>
            }
            else
            {
                # returns int value of affected rows
                $sql.command.ExecuteNonQuery()
            }
        }
    }

    end
    {
        $sql.connection.Close()
    }
}
