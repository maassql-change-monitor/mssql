<# user editable settings -------------------------- #>
$SCRIPT:scripted_db_directory_must_sit_idle_for_x_minutes   = 5
$SCRIPT:directories_to_grab_at_a_time                       = 100;
$SCRIPT:synch_every_X_seconds                               = 10 # ( $seconds_in_an_hour / 2 )
$SCRIPT:stop_the_script_after_X_hours                       = 24
$SCRIPT:scripted_db_directory_base_path                     = "F:\sql_compare\scripted_dbs"
$SCRIPT:scm_db_script_directory_base                        = "F:\scm_databases"
$SCRIPT:web_server_url                                      = "http://nghsdemosql:81" 
<# user editable settings -------------------------- #>

<# BELOW IS ALL code DO NOT EDIT -------------------------- #>
$my_fullname                            = ($MyInvocation.MyCommand.Definition)
$SCRIPT:my_dir_config_ps1               = ( Split-Path $my_fullname )

$SCRIPT:changes_observed                                    = @{};
$SCRIPT:scm_db_script_name                                  = "{server_instance}.{database}"
$SCRIPT:code_common_directory                               = ( Resolve-Path "$SCRIPT:my_dir_config_ps1\..\..\..\common" )
$SCRIPT:my_exit_loop_flag_file                              = "$($SCRIPT:my_dir_config_ps1)\flag_file.stop"
$SCRIPT:maassql_change_monitor_loc                          = ( Resolve-Path"$SCRIPT:code_common_directory\..\" )
$SCRIPT:httpd_html_loc                                      = "$($SCRIPT:maassql_change_monitor_loc)/mssql/mssql/scripted_to_scm/html"
$SCRIPT:httpd_html_reports_loc                              = "$($SCRIPT:httpd_html_loc)/reports/"
$SCRIPT:httpd_html_infrastructure_loc                       = "$($SCRIPT:httpd_html_loc)/infrastructure/"



$SCRIPT:httpd_conf_file = "$SCRIPT:my_dir_config_ps1\make_httpd_scripted_to_scm_conf.conf"
. "$($SCRIPT:my_dir_config_ps1 )\config\httpd_scripted_to_scm_conf_make.ps1"
make_httpd_scripted_to_scm_conf







function config_as_html
{
    $config = @"
<table>
    
</table>
"@
    return @config  
}



write-host "configuration has been loaded"