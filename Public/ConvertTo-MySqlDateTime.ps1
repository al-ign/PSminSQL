function ConvertTo-MySqlDateTime {
    process {
        foreach ($value in $input) {
            #$value.GetType().name
            "(STR_TO_DATE('{0}','%Y-%m-%d %T'))" -f (($value).ToString('u') -replace 'Z$')
            }
        }
    }
