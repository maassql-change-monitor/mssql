function html_file_report_every_check_by_date_checked ($dt_checked)
    {
        $html_file_name = "$($SCRIPT:httpd_html_reports_loc)\checks_by_date_checked\{dttm} every_check.html" 
        $html_file_name = ( replace_date ($dt_checked) $html_file_name )
        $null = (setup_html_file ($html_file_name))
        write-host "returning filename=[$html_file_name]"
        return $html_file_name
    }

function html_file_report_changes_detected_by_date_checked ($dt_checked)
    {
        $html_file_name = "$($SCRIPT:httpd_html_reports_loc)\checks_by_date_checked\{dttm} changes_detected.html"
        $html_file_name = ( replace_date ($dt_checked) $html_file_name )
        $null = (setup_html_file ($html_file_name))
        return $html_file_name         
    }

function html_file_report_every_check_by_date_recorded
    {
        $html_file_name = "$($SCRIPT:httpd_html_reports_loc)\checks_by_date_recorded\{dttm} every_check.html"
        $html_file_name = ( replace_date (Get-Date) $html_file_name )
        $null = (setup_html_file ($html_file_name))
        return $html_file_name        
    }

function html_file_report_changes_detected_by_date_recorded
    {
        $html_file_name = "$($SCRIPT:httpd_html_reports_loc)\checks_by_date_recorded\{dttm} changes_detected.html"
        $html_file_name = ( replace_date (Get-Date) $html_file_name )
        $null = (setup_html_file ($html_file_name))
        return $html_file_name        
    }

function html_file_report_every_check_by_instance($scrptd)
    {
        $html_file_name = "$($SCRIPT:httpd_html_reports_loc)\checks_by_instance\$($scrptd.instance) every_check.html"
        $null = (setup_html_file ($html_file_name))
        return $html_file_name        
    }

function html_file_report_changes_detected_by_instance($scrptd)
    {
        $html_file_name = "$($SCRIPT:httpd_html_reports_loc)\checks_by_instance\$($scrptd.instance) changes_detected.html"
        $null = (setup_html_file ($html_file_name))
        return $html_file_name        
    }

function html_file_report_every_check_dbname($scrptd)
    {
        $html_file_name = "$($SCRIPT:httpd_html_reports_loc)\checks_by_dbname\$($scrptd.dbname) {dttm} every_check.html"
        $dt_checked = ( scripted_checked_date $scrptd )
        $html_file_name = ( replace_date $dt_checked $html_file_name )
        $null = (setup_html_file ($html_file_name))
        return $html_file_name   
    }

function html_file_report_changes_detected_by_dbname($scrptd)
    {
        $html_file_name = "$($SCRIPT:httpd_html_reports_loc)\checks_by_dbname\($scrptd.dbname) {dttm} changes_detected.html"
        $dt_checked = ( scripted_checked_date $scrptd )
        $html_file_name = ( replace_date $dt_checked $html_file_name )        
        $null = (setup_html_file ($html_file_name))
        return $html_file_name        
    }


function replace_date($dt, $str)
{
    return ( $str.Replace('{dttm}', $dt.ToUniversalTime().ToString("yyyy.MM.dd")) )
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
        </tr>
    </table>    



"@
    return $str
}

function setup_html_file ($html_file_name)
{
    write-host "setting up html report =[$html_file_name]."


    if ((Test-Path -LiteralPath:$html_file_name) -eq $false )
    {
        $(html_top) >> $html_file_name
    }
    return $null
}


function scripted_checked_date ($scrptd)
{
    $checked_as_date = [System.Convert]::ToDateTime( ($scrptd.'dttm').insert(4, '.').insert(7, '.').insert(13, ':').Substring(0,16) )
    return $checked_as_date
}