$my_fullname_scripted_to_scm_psm1_vars_ps1        = ($MyInvocation.MyCommand.Definition)
$my_dir_scripted_to_scm_psm1_vars_ps1             = ( Split-Path $my_fullname_scripted_to_scm_psm1_vars_ps1 )



<# 
=======================================================================================================================
DB Scripting
#>
$SCRIPT:scripted_db_directory_base_path="F:\sql_compare\scripted_dbs"
$SCRIPT:scm_db_script_directory_base="F:\scm_databases"
$SCRIPT:scm_db_script_name="{server_instance}.{database}"



<# 
=======================================================================================================================
Check In Process
#>
$SCRIPT:scripted_db_directory_must_sit_idle_for_x_minutes   = 0
$SCRIPT:directories_to_grab_at_a_time                       = 10;
$SCRIPT:stop_the_script_after_X_hours                       = 24
$SCRIPT:synch_every_X_seconds                               = 10 
$SCRIPT:my_exit_loop_flag_file                              = "$($my_dir_scripted_to_scm_psm1_vars_ps1)\config\flag_file.stop"



<# 
=======================================================================================================================
Web Server
#>
$SCRIPT:web_server_file_system_base = "C:\DBATools\maassql-change-monitor\mssql\mssql\scripted_to_scm\html"
function url_web_server_base
{
    return "http://nghsdemosql:81"
}

<# 
=======================================================================================================================
DB Script to SCM Database
#>

$SCRIPT:MSSQL_SCM_ServerInstance    = "nghsdemosql"
$SCRIPT:MSSQL_SCM_Database          = "maassql.change_monitoring.mssql"

write-host "vars has been included....."