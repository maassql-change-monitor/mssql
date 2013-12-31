function scripted_checked_date ($scrptd)
{
    $checked_as_date = [System.Convert]::ToDateTime( ($scrptd.'dttm').insert(4, '.').insert(7, '.').insert(13, ':').Substring(0,16) )
    return $checked_as_date
}