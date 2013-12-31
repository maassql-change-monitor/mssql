function schema_checkin_as_html ( $scrptd , $change_detected )
{
    $who = "$($scrptd.'instance').$($scrptd.'dbname')"
    $instance = $scrptd.'instance'
    $db_name = $scrptd.'dbname'
    $checked_as_date = ( scripted_checked_date $scrptd )
    $checked_as_date_string = $checked_as_date.ToString("yyyy.MM.dd")
    $checked = $checked_as_date.ToString("yyyy.MM.dd HH:mm")
    $now = (Get-Date)
    $now_f = ($now).ToUniversalTime().ToString("yyyy.MM.dd HH:mm")

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

    <table class="db_change_check $($changed)">
        <tr>
            <td class="checked_date $($changed)"              >
                $(reports_by $checked (url_check_history_date_checked_every($checked_as_date)) (url_check_history_date_checked_changes_only($checked_as_date)) )
            </td>

            <td class="recorded_date $($changed)"             >
                $(reports_by $now_f ( url_check_history_date_recorded_every($now) ) ( url_check_history_date_recorded_changes_only($now) ) )
            </td>

            <td class="was_changed $($changed)"               >
                $changed
            </td>

            <td class="link_to_git_head $($changed)"          >
                $(url_as_link $url_diff $who)
            </td>

            <td class="link_to_instance_check_history"              >
                $(reports_by $instance ( url_check_history_instance_every($instance) ) ( url_check_history_instance_changes_only($instance) ) )
            </td>

            <td class="link_to_DB_check_history"                    >
                $(reports_by $db_name ( url_check_history_database_every($db_name) ) ( url_check_history_database_changes_only($db_name) ) )
            </td>            
        </tr>
    </table>    
"@

    return $html
}


function reports_by ( $text, $url_every, $url_changed)
{
    return "$(url_as_link $url_every $text)<br/>$(url_as_link $url_changed 'changes')"  
}


function url_as_link($url, $text)
{
    return "<a href='$($url)' target='$url'>$($text)</a>"  
}


function html_top ()
{
    $str=@"
<!DOCTYPE html>
<html lang="en-US">
<head>
<meta http-equiv="refresh" content="60">
<title>MSSQL Schema Monitoring</title>
<link rel="stylesheet" type="text/css" href="/msssql_scm/infrastructure/scripted_to_scm_stylesheet.css" />
</head>
<body>

<div class=refresh_note>Page refreshes every 60 seconds.</div>





    <table class="db_change_check header">
        <tr>
            <td class="checked_date header"              >Date Checked</td>
            <td class="recorded_date header"             >Date Recorded</td>
            <td class="was_changed header"               >Changed ?</td>
            <td class="link_to_git_head header"          >Database Schema History</td>
            <td class="link_to_instance_history"         >Instance Check History</td>
            <td class="link_to_DB_history"               >DB Check History</td>
        </tr>
    </table>    



"@
    return $str
}
