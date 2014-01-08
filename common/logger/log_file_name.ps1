Function GLOBAL:log_file_name
{
    $log_now_folder="$($SCRIPT:Log_directory)\$(get_sortable_date_hour)\"
    New-Item $log_now_folder -type directory -force
    return "$log_now_folder\$($GLOBAL:log_me_as_logger_name)_$(get_sortable_date_hour)_pid.$pid.log"
}