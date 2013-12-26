function url_last_change ($scrptd)
{
    $url_base=( url_base $scrptd )
    return "$url_base;a=commitdiff;h=HEAD" 
}