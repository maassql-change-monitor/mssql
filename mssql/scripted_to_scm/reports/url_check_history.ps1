function url_reports_base
{
    return ("$(url_web_server_base)/msssql_scm/reports/")
}




<# 
=======================================================================================================================
Check History
#>
function url_check_history_instance_every($instance)
{
    "$(url_reports_base)reports/"   
}
function url_check_history_instance_changes_only($instance)
{
    "$(url_reports_base)/reports/checks_by_instance/ASHSQL1_ASHPROD%20every_check.html"   
}
function url_check_history_database_every($db_name)
{
    "$(url_reports_base)/reports/checks_by_dbname/"   
}
function url_check_history_database_changes_only($db_name)
{
    "$(url_reports_base)/reports/checks_by_dbname/"   
}
function url_check_history_date_checked_every($date_scripted)
{
   "$(url_reports_base)/reports/checks_by_date_checked/{dttm}_every_check"
}
function url_check_history_date_checked_changes_only($date_scripted)
{
    "$(url_reports_base)/reports/checks_by_date_checked/{dttm}_every_check"
}
function url_check_history_date_recorded_every($date_recorded)
{
    "$(url_reports_base)/reports/checks_by_date_recorded/2013.12.30%20changes_detected.html"
}
function url_check_history_date_recorded_changes_only($date_recorded)
{
   "$(url_reports_base)/reports/checks_by_date_recorded/2013.12.30%20changes_detected.html" 
}



