function html_file_report_every_check_by_date_checked ($dt_checked)
    {
        $html_file_name = "$($SCRIPT:httpd_html_reports_loc)\checks_by_date_checked\{dttm} changes_detected.html" 
        $html_file_name = ( replace_date ($dt_checked) $html_file_name )
        setup_html_file ($html_file_name)
        return $html_file_name
    }

function html_file_report_changes_detected_by_date_checked ($dt_checked)
    {
        $html_file_name = "$($SCRIPT:httpd_html_reports_loc)\checks_by_date_checked\{dttm} every_check.html"
        $html_file_name = ( replace_date ($dt_checked) $html_file_name )
        setup_html_file ($html_file_name)
        return $html_file_name         
    }

function html_file_report_every_check_by_date_recorded
    {
        $html_file_name = "$($SCRIPT:httpd_html_reports_loc)\checks_by_date_recorded\{dttm} changes_detected.html"
        $html_file_name = ( replace_date (Get-Date) $html_file_name )
        setup_html_file ($html_file_name)
        return $html_file_name        
    }

function html_file_report_changes_detected_by_date_recorded
    {
        $html_file_name = "$($SCRIPT:httpd_html_reports_loc)\checks_by_date_recorded\{dttm} every_check.html"
        $html_file_name = ( replace_date (Get-Date) $html_file_name )
        setup_html_file ($html_file_name)
        return $html_file_name        
    }

function html_file_report_every_check_by_instance($scrptd)
    {
        $html_file_name = "$($SCRIPT:httpd_html_reports_loc)\checks_per_instance\$($scrptd.instance) changes_detected.html"
        setup_html_file ($html_file_name)
        return $html_file_name        
    }

function html_file_report_changes_detected_by_instance($scrptd)
    {
        $html_file_name = "$($SCRIPT:httpd_html_reports_loc)\checks_per_instance\$($scrptd.instance) every_check.html"
        setup_html_file ($html_file_name)
        return $html_file_name        
    }

function html_file_report_every_check_dbname($scrptd)
    {
        $html_file_name = "$($SCRIPT:httpd_html_reports_loc)\checks_per_dbname\$($scrptd.dbname) changes_detected.html"
        setup_html_file ($html_file_name)
        return $html_file_name   
    }

function html_file_report_changes_detected_by_dbname($scrptd)
    {
        $html_file_name = "$($SCRIPT:httpd_html_reports_loc)\checks_per_dbname\($scrptd.dbname) every_check.html"
        setup_html_file ($html_file_name)
        return $html_file_name        
    }


function replace_date($dt, $str)
{
    return ( $str.Replace('{dttm}', $dt.ToUniversalTime().ToString("yyyy.MM.dd")) )
}

function html_top ( $css_file )
{
    $str=@"
<!DOCTYPE html>
<html lang="en-US">
<head>
<meta http-equiv="refresh" content="60">
<title>MSSQL Schema Monitoring</title>
<link rel="stylesheet" type="text/css" href="$(stylesheet_file_name)" />
</head>
<body>

<div class=refresh_note>Page refreshes every 60 seconds.</div>

<table class='db_change_check'><tr><td>When Checked</td><td>When Recorded</td><td>Changed ?</td><td>Last Chagne</td><td>Database</td></tr></table>
"@
    return $str
}

function stylesheet_file_name
{
    return "$($SCRIPT:httpd_html_infrastructure_loc)\scripted_to_scm_stylesheet.css" 
}


function setup_html_file ($html_file_name)
{
    if ((Test-Path -LiteralPath:$html_file_name) -eq $false )
    {
        $(html_top -css_file:(stylesheet_file_name)) >> $html_file_name
    }
    return $null
}


function scripted_checked_date ($scrptd)
{
    $checked_as_date = [System.Convert]::ToDateTime( ($scrptd.'dttm').insert(4, '.').insert(7, '.').insert(13, ':').Substring(0,16) )
    return $checked_as_date
}