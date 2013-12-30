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

<title>MSSQL Schema Monitoring</title>
<link rel="stylesheet" type="text/css" href="$(stylesheet_file_name)" />
</head>
<body>
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



<#


$this_day = (Get-Date).ToUniversalTime().ToString("yyyy.MM.dd")

$SCRIPT:change_check_log = "$($my_dir)\html\checks_by_date_recorded\$($this_day) change_check_log.xml"
$SCRIPT:change_html_every = "$($my_dir)\html\checks_by_date_recorded\$($this_day) every_check.html"
$SCRIPT:change_html_changes = "$($my_dir)\html\checks_by_date_recorded\$($this_day) changes_detected.html"


$SCRIPT:change_html_every_by_checked_date = "$($my_dir)\html\checks_by_date_checked\{dttm} every_check.html"
$SCRIPT:change_html_changes_by_checked_date = "$($my_dir)\html\checks_by_date_checked\{dttm} changes_detected.html"




function check_for_changes_html ( $scrptd , $change_detected )
{
    $who = "$($scrptd.'instance').$($scrptd.'dbname')"

    $checked_as_date = [System.Convert]::ToDateTime( ($scrptd.'dttm').insert(4, '.').insert(7, '.').insert(13, ':').Substring(0,16) )
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

    $st="style='border:1px solid black;'"
    $html = "<table $($st)><tr $($st)><td $($st)>$checked</td><td>$now</td><td $($st)>$changed</td><td><a href='$url_diff' target='_blank'>$who</a></td></tr></table>"
    
    $html >> $SCRIPT:change_html_every
    $html >> $SCRIPT:change_html_every_by_checked_date.Replace('{dttm}', $checked_as_date_string) 


    if ( $change_detected -eq $true )
    {
      $html >> $SCRIPT:change_html_changes 
      $html >> $SCRIPT:change_html_changes_by_checked_date.Replace('{dttm}', $checked_as_date_string) 
    }





}
#>