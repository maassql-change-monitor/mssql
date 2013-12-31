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

