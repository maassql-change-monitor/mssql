function check_for_changes_html ( $scrptd , $change_detected )
{
    $who = "$($scrptd.'instance').$($scrptd.'dbname')"
    $checked = ($scrptd.'dttm')
    $url_diff = (url_last_change $scrptd)
    $url_diff = "<a href='$url_diff' target='_blank'>Last Change</a>"
    $html = "<table class='db_change_check'><tr><td>$checked</td><td>change=$change_detected</td><td>$who</td><td>$url_diff</td></tr></table>"
    $html >> $SCRIPT:change_html_every
    if ( $change_detected -eq $true )
    {
      $html >> $SCRIPT:change_html_changes  
    }
}