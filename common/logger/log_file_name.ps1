Function GLOBAL:log_file_name ( $log_name=$null )
{
    if ($log_name -eq $null)
    {
        $log_name = $GLOBAL:log_me_as_logger_name
    }
    $log_now_folder="$($SCRIPT:Log_directory)\$(get_sortable_date_hour)\"
    $null = (New-Item -path:$log_now_folder -type:directory -force)
    return "$log_now_folder\$($log_name)_$(get_sortable_date_hour)_pid.$pid.log"
}