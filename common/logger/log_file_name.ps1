Function log_file_name
{
    return "$($SCRIPT:Log_directory)\scripted_to_scm_log_$(get_sortable_date_hour).log"
}