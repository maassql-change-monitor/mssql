<# filesystem #>
$SCRIPT:httpd_html_reports_loc = "$SCRIPT:web_server_file_system_base\reports\"
$SCRIPT:httpd_html_infrastructure_loc = "$SCRIPT:web_server_file_system_base\infrastructure\"


function setup_html_file ($html_file_name)
{
    write-host "setting up html report =[$html_file_name]."
    $html_file_name = "$($SCRIPT:httpd_html_reports_loc)/$html_file_name"
    if ((Test-Path -LiteralPath:$html_file_name) -eq $false )
    {
        $(html_top) >> $html_file_name
    }
    return $html_file_name
}

function html_file_report_every_check_by_date_checked ($dt_checked)
    {
        $html_file_name = (setup_html_file (file_name_check_history_date_checked_every $dt_checked))
        return $html_file_name
    }

function html_file_report_changes_detected_by_date_checked ($dt_checked)
    {
        $html_file_name = (setup_html_file (file_name_check_history_date_checked_changes_only $dt_checked))
        return $html_file_name         
    }

function html_file_report_every_check_by_date_recorded
    {
        $html_file_name = (setup_html_file (file_name_check_history_date_recorded_every (Get-Date)))
        return $html_file_name        
    }

function html_file_report_changes_detected_by_date_recorded
    {
        $html_file_name = (setup_html_file (file_name_check_history_date_recorded_every (Get-Date)))
        return $html_file_name        
    }

function html_file_report_every_check_by_instance($scrptd)
    {
        $html_file_name = (setup_html_file ($file_name_check_history_instance_every $scrptd.instance))
        return $html_file_name        
    }

function html_file_report_changes_detected_by_instance($scrptd)
    {
        $html_file_name = (setup_html_file (file_name_check_history_instance_changes_only $scrptd.instance))
        return $html_file_name        
    }

function html_file_report_every_check_dbname($scrptd)
    {
        $html_file_name = (setup_html_file (file_name_check_history_database_every $scrptd.dbname))
        return $html_file_name   
    }

function html_file_report_changes_detected_by_dbname($scrptd)
    {
        $html_file_name = (setup_html_file (file_name_check_history_database_changes_only $scrptd.dbname))
        return $html_file_name        
    }

function processing_log_file()
{
    $file_name = "$($SCRIPT:httpd_html_reports_loc)\processing_log\{dttm} processing_log     $GLOBAL:earliest_instance to $GLOBAL:latest_instance.csv" 
    $file_name = ( replace_date (Get-Date) $file_name )
    return $file_name  
}