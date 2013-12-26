$this_day = (Get-Date).ToUniversalTime().ToString("yyyy.MM.dd_(zz)_HH-mm")

function html_file_showing_every_check
{
    
    $file = "$($my_dir)\html\$($this_day)_every_check.html"  
    $null = (setup_html_file -html_file_name:$file ) 
    return $file
}

function html_file_showing_changed_databases
{
    $file = "$($my_dir)\html\$($this_day)_changes_detected.html" 
    $null = (setup_html_file -html_file_name:$file )
    return $file
}

function stylesheet_file_name
{
    return "$($my_dir)\html\scripted_to_scm_stylesheet.css" 
}

function setup_html_file ($html_file_name)
{
    if ((Test-Path -LiteralPath:$html_file_name) -eq $false )
    {
        $(html_top -css_file:(stylesheet_file_name) >> $html_file_name
    }
}

function html_top ( $css_file )
{
    $str=@"
<!DOCTYPE html>
<html lang="en-US">
<head>

<title>MSSQL Source Control Monitoring</title>
<link rel="stylesheet" type="text/css" href="$css_file" />
</head>
<body>
"@
    return $str
}
