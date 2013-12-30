$SCRIPT:httpd_html_reports_loc = "C:\DBATools\maassql-change-monitor\mssql\mssql\scripted_to_scm\html"
$SCRIPT:scripted_db_directory_base_path="F:\sql_compare\scripted_dbs"
$SCRIPT:scm_db_script_directory_base="F:\scm_databases"
$SCRIPT:scm_db_script_name="{server_instance}.{database}"
$SCRIPT:scripted_db_directory_must_sit_idle_for_x_minutes = 0
$SCRIPT:directories_to_grab_at_a_time=10;
$SCRIPT:stop_the_script_after_X_hours = 24
$SCRIPT:synch_every_X_seconds = 10 




$SCRIPT:code_common_directory=( Resolve-Path "$my_dir\..\..\common" )
$SCRIPT:my_exit_loop_flag_file = "$($my_dir)\config\flag_file.stop"











write-host "vars has been included....."