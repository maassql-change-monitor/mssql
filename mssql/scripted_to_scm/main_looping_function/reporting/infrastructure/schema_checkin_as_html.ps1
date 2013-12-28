function schema_checkin_as_html($scrptd)
{
    [string] $when_detected_formatted = ($scrptd.dttm).ToString("yyyy.MM.dd_HH-mm")

    $who = "$($scrptd.'instance').$($scrptd.'dbname')"
    $checked = ($scrptd.'dttm')
    $url_diff = (url_last_change $scrptd)
    $url_diff = "<a href='$url_diff' target='_blank'>Last Change</a>"
    $now=(Get-Date).ToString("yyyy.MM.dd_(zz)_HH-mm")
    $html = "<table class='db_change_check'><tr><td>$checked</td><td>$now</td><td>$change_detected</td><td>$url_diff</td><td>$who</td></tr></table>"

    return $html

    if ($x -eq $true)
}