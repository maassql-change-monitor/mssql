function replace_date($dt, $str)
{
    return ( $str.Replace('{dttm}', $dt.ToUniversalTime().ToString("yyyy.MM.dd")) )
}




function file_name_check_history_date_checked_every($date_scripted)
{
    return "$(replace_date $date_scripted "\checks_by_date_checked\{dttm}_every_check.html")"
}
function file_name_check_history_date_checked_changes_only($date_scripted)
{
    return "$(replace_date $date_scripted "\checks_by_date_checked\{dttm} changes_detected.html")" 
}


function file_name_check_history_date_recorded_every($date_recorded)
{
    return "$(replace_date $date_recorded "\checks_by_date_recorded\{dttm} every_check.html")"
}
function file_name_check_history_date_recorded_changes_only($date_recorded)
{
    return "$(replace_date $date_recorded "\checks_by_date_recorded\{dttm} changes_detected.html")"
}






function file_name_check_history_instance_every($instance)
{
    return "\checks_by_instance\$($instance) every_check.html" 
}
function file_name_check_history_instance_changes_only($instance)
{
    return "\checks_by_instance\$($instance) changes_detected.html"
}







function file_name_check_history_database_every($db_name)
{
    return "\checks_by_dbname\$($db_name) every_check.html"   
}
function file_name_check_history_database_changes_only($db_name)
{
    return "\checks_by_dbname\$($db_name) changes_detected.html"   
}


