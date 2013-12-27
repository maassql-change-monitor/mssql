function git_web_url_last_change ($scrptd)
{
    $git_web_url_base=( git_web_url_base $scrptd )
    return "$git_web_url_base;a=commitdiff;h=HEAD" 
}