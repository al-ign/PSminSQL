# PSminSQL
Minimal PS wrapper for .NET SQL connectors

# Usage

Call `Register-Assemblies.ps1` with the path to .NET SQL connector assemblies  
Use Invoke-SQLQuery to make queries

# Example

```
$Splat = @{
    Provider = 'MySql'
    ConnectionString = "Server=localhost;port=3306;user=root;password=root;database=mysql"
    Query = "Select * FROM help_keyword"
    }

$output = Invoke-SqlQuery @Splat
```
