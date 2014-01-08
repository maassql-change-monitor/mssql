Function GLOBAL:log_file_name
{
    return "$($SCRIPT:Log_directory)\$($GLOBAL:log_me_as_logger_name)_$(get_sortable_date_hour)_pid.$pid.log"
}