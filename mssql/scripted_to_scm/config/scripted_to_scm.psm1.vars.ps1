
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
$SCRIPT:scripted_db_directory_must_sit_idle_for_x_minutes = 0
$SCRIPT:directories_to_grab_at_a_time=10;
$SCRIPT:stop_the_script_after_X_hours = 24
$SCRIPT:synch_every_X_seconds = 10 
$SCRIPT:my_exit_loop_flag_file = "$($my_dir)\config\flag_file.stop"



<# 
=======================================================================================================================
Web Server
#>
$SCRIPT:web_server_file_system_base = "C:\DBATools\maassql-change-monitor\mssql\mssql\scripted_to_scm\html"
function url_web_server_base
{
    return "http://nghsdemosql:81"
}

<# filesystem #>
$SCRIPT:httpd_html_reports_loc = "$SCRIPT:web_server_file_system_base\reports\"
$SCRIPT:httpd_html_infrastructure_loc = "$SCRIPT:web_server_file_system_base\infrastructure\"

function url_reports_base
{
    return ("$(url_web_server_base)/msssql_scm/"
}


<# 
=======================================================================================================================
Gitweb
#>

function url_git_web_base ()
{
    return "$(url_web_server_base)/gitweb/"
}

function url_all_db_repositories ()
{
    return ( url_git_web_base ) 
}

function url_git_web_db_base ($scrptd)
{
    return "$(url_git_web_base)/gitweb.cgi?p=$($scrptd.'instance').$($scrptd.'dbname')/.git"
}

function url_last_change ($scrptd)
{
    $url_db_base=( url_git_web_db_base $scrptd )
    return "$($url_db_base);a=commitdiff;h=HEAD" 
}


<#
        Last Change Details     = $url_base;a=commitdiff;h=HEAD   
        Summary                 = $url_base;a=summary
        Check History           = $url_base;a=tags
        Files                   = $url_base;a=tree
        Last Change             = $url_base;a=commit;h=HEAD
        Changes                 = $url_base;a=shortlog
        Changes Detailed        = $url_base;a=log;h=HEAD
#>





write-host "vars has been included....."