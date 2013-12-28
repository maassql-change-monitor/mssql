$right_now = (Get-Date).ToUniversalTime().ToString("yyyy.MM.dd_HH-mm")

function setup_html_report ( $report_ps1_file_name )
{
    $just_file_name =  "$($right_now)_$(Split-Path -Leaf $report_ps1_file_name)".replace('.ps1', '')
    $full_file_name = "$($SCRIPT:httpd_html_loc)/$just_file_name"
    $null = (setup_html_file -html_file_name:$full_file_name ) 
    return $full_file_name 
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
    return "$($my_dir)\html\scripted_to_scm_stylesheet.css" 
}


<#


$this_day = (Get-Date).ToUniversalTime().ToString("yyyy.MM.dd")

$SCRIPT:change_check_log = "$($my_dir)\html\checks_by_date_recorded\$($this_day) change_check_log.xml"
$SCRIPT:change_html_every = "$($my_dir)\html\checks_by_date_recorded\$($this_day) every_check.html"
$SCRIPT:change_html_changes = "$($my_dir)\html\checks_by_date_recorded\$($this_day) changes_detected.html"


$SCRIPT:change_html_every_by_checked_date = "$($my_dir)\html\checks_by_date_checked\{dttm} every_check.html"
$SCRIPT:change_html_changes_by_checked_date = "$($my_dir)\html\checks_by_date_checked\{dttm} changes_detected.html"



    $st="style='border:1px solid black;'"
    $html = "<table $($st)><tr $($st)><td $($st)>$checked</td><td>$now</td><td $($st)>$changed</td><td><a href='$url_diff' target='_blank'>$who</a></td></tr></table>"
    
    $html >> $SCRIPT:change_html_every
    $html >> $SCRIPT:change_html_every_by_checked_date.Replace('{dttm}', $checked_as_date_string) 


    if ( $change_detected -eq $true )
    {
      $html >> $SCRIPT:change_html_changes 
      $html >> $SCRIPT:change_html_changes_by_checked_date.Replace('{dttm}', $checked_as_date_string) 
    }
#>