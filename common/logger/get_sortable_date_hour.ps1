Function get_sortable_date_hour
{
    [cmdletbinding()]
    Param (
        [Parameter(Mandatory=$False)][datetime]$to_format = (Get-Date)
    )
    [string]$ret_dt_formatted = ""
    $ret_dt_formatted = $to_format.ToUniversalTime().ToString("yyyy.MM.dd.HH")
    return($ret_dt_formatted)
}