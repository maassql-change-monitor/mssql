function check_for_changes_html ( $scrptd , $change_detected )
{
    $who = "$($scrptd.'instance').$($scrptd.'dbname')"
    $checked = ($scrptd.'dttm')
    $url_diff = (url_last_change $scrptd)
    $url_diff = "<a href='$url_diff' target='_blank'>Last Change</a>"
    $html = "<table style='border:1px solid black;'><tr style='border:1px solid black;'><td style='border:1px solid black;'>$checked</td><td style='border:1px solid black;'>change=$change_detected</td><td style='border:1px solid black;'>$who</td><td style='border:1px solid black;'>$url_diff</td></tr></table>"
    $html >> $SCRIPT:change_html_every
    if ( $change_detected -eq $true )
    {
      $html >> $SCRIPT:change_html_changes  
    }
}