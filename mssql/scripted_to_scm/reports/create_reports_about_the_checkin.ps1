function create_reports_about_the_checkin ( $scrptd , $change_detected )
{
    $html = ( schema_checkin_as_html $scrptd  $change_detected )
    $checked_as_date = ( scripted_checked_date $scrptd )

    $null = ( shared_write_to_common_file ( html_file_report_every_check_by_date_recorded ) $html )
    $null = ( shared_write_to_common_file ( html_file_report_every_check_by_date_checked ($checked_as_date) ) $html )
    $null = ( shared_write_to_common_file ( html_file_report_every_check_by_instance $scrptd) $html )
    $null = ( shared_write_to_common_file ( html_file_report_every_check_dbname $scrptd) $html )

    if ( $change_detected -eq $true )
    {

        $null = ( shared_write_to_common_file ( html_file_report_changes_detected_by_date_recorded ) $html )
        $null = ( shared_write_to_common_file  ( html_file_report_changes_detected_by_date_checked ($checked_as_date) ) $html )
        $null = ( shared_write_to_common_file ( html_file_report_changes_detected_by_instance $scrptd) $html )
        $null = ( shared_write_to_common_file ( html_file_report_changes_detected_by_dbname $scrptd) $html )
    }
    return $null
}