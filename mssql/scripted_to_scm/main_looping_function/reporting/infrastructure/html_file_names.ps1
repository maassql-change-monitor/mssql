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
