Function GLOBAL:log_file_name
{
    return "$($SCRIPT:Log_directory)\log_this_$(get_sortable_date_hour)_$pid.log"
}