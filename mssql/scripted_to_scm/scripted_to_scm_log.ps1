Function scripted_to_scm_log ($to_log)
{
    $to_log = "$(Get-Date) | $to_log" 
    $to_log >> log_file_name
}

Function log_file_name
{
    return "$($SCRIPT:scm_db_script_directory_base)\scripted_to_scm_log_$(get_sortable_date_hour).log"
}

Function get_sortable_date_hour
{
    [cmdletbinding()]
    Param (
        [Parameter(Mandatory=$False)][datetime]$to_format = (Get-Date)
    )
    [string]$ret_dt_formatted = ""
    $ret_dt_formatted = $to_format.ToUniversalTime().ToString("yyyyMMddzzHH")
    return($ret_dt_formatted)
}