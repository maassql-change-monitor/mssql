function log_the_check_for_changes( $scrptd , $change_detected)
{
    $x_to_scm = (xml_tag "to_scm" ((Get-Date).ToUniversalTime().ToString("yyyyMMddzz HH:MM:SS")))
    $x_instance = (xml_tag "mssql_instance" ($scrptd.'instance'))
    $x_db_name = (xml_tag "db" ($scrptd.'dbname'))
    $x_checked_when = (xml_tag "checked_when" ($scrptd.'dttm'))
    $x_checked_deteced = (xml_tag "change_detected" $change_detected)
    $x_diff_url = (xml_tag "diff_url" (url_last_change $scrptd))
    $to_log = "$x_checked_when $x_to_scm $x_checked_deteced $x_instance $x_db_name $x_diff_url" 
    $to_log  >> ($SCRIPT:change_check_log)
}