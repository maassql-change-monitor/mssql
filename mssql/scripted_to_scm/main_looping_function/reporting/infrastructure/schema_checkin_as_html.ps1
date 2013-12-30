function schema_checkin_as_html ( $scrptd , $change_detected )
{
    $who = "$($scrptd.'instance').$($scrptd.'dbname')"

    $checked_as_date = ( scripted_checked_date $scrptd )
    $checked_as_date_string = $checked_as_date.ToString("yyyy.MM.dd")
    $checked = $checked_as_date.ToString("yyyy.MM.dd HH:mm")
    $now = (Get-Date).ToUniversalTime().ToString("yyyy.MM.dd HH:mm")

    $url_diff = (url_last_change $scrptd)
    if ($change_detected -eq $true)
    {
        $changed = 'CHANGED'
    }
    else
    {
        $changed = 'same'
    }

    $html = @"


    <table class="db_change_check $changed">
        <tr>
            <td class="checked_date"              >$checked</td>
            <td class="recorded_date"             >$now</td>
            <td class="was_changed $changed"      >$changed</td>
            <td class="link_to_git_head"          ><a href='$url_diff' target='_blank'>$who</a></td>
        </tr>
    </table>    
"@

    return $html
}

