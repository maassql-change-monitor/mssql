$SCRIPT:code_common_directory=( Resolve-Path "$my_dir\..\..\common" )
$SCRIPT:my_exit_loop_flag_file = "$($my_dir)\config\flag_file.stop"


function todays_date_for_file
{
    return ( (Get-Date).ToUniversalTime().ToString("yyyy.MM.dd") )
}

<# at what directory is the webserver pointing ?#>
$report_folder_html = "C:\DBATools\maassql-change-monitor\mssql\mssql\scripted_to_scm\html"

$SCRIPT:change_html_every                   = "$report_folder_html\checks_by_date_recorded\$(todays_date_for_file) every_check.html"
$SCRIPT:change_html_changes                 = "$report_folder_html\checks_by_date_recorded\$(todays_date_for_file) changes_detected.html"

$SCRIPT:change_html_every_by_checked_date   = "$report_folder_html\checks_by_date_checked\{dttm} every_check.html"
$SCRIPT:change_html_changes_by_checked_date = "$report_folder_html\checks_by_date_checked\{dttm} changes_detected.html"



function report_html_every_check
{

}

function report_html_change_detected







$SCRIPT:scripted_db_directory_base_path="F:\sql_compare\scripted_dbs"
$SCRIPT:scm_db_script_directory_base="F:\scm_databases"
$SCRIPT:scm_db_script_name="{server_instance}.{database}"
$SCRIPT:scripted_db_directory_must_sit_idle_for_x_minutes = 0
$SCRIPT:directories_to_grab_at_a_time=10;

<# synch frequency #>
$seconds_in_minute = 60
$seconds_in_an_hour = ( $seconds_in_minute * 60 )
$SCRIPT:synch_every_X_seconds = 10 # ( $seconds_in_an_hour / 2 )

<# stop the script after X hours #>
$SCRIPT:stop_the_script_after_X_hours = 24

write-host "vars has been included....."