function url_reports_base
{
    return ("$(url_web_server_base)/msssql_scm/reports/")
}




<# 
=======================================================================================================================
Check History
#>

function url_check_history_date_checked_every($date_scripted)
{
   "$(url_reports_base)$(file_name_check_history_date_checked_every $date_scripted))" 
}
function url_check_history_date_checked_changes_only($date_scripted)
{
    "$(url_reports_base)$(file_name_check_history_date_checked_changes_only $date_scripted))" 
}

function url_check_history_date_recorded_every($date_recorded)
{
    "$(url_reports_base)$(file_name_check_history_date_recorded_every $date_recorded))" 
}
function url_check_history_date_recorded_changes_only($date_recorded)
{
   "$(url_reports_base)$(file_name_check_history_date_recorded_changes_only $date_recorded))" 
}

function url_check_history_instance_every($instance)
{
    "$(url_reports_base)$(file_name_check_history_instance_every $instance))"   
}
function url_check_history_instance_changes_only($instance)
{
    "$(url_reports_base)$(file_name_check_history_instance_changes_only $instance))"   
}











function url_check_history_database_every($db_name)
{
    "$(url_reports_base)$(file_name_check_history_database_every $db_name))"   
}
function url_check_history_database_changes_only($db_name)
{
    "$(url_reports_base)$(file_name_check_history_database_changes_only $db_name))"   
}





