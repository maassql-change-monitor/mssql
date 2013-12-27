function setup_html_file ($html_file_name)
{
    if ((Test-Path -LiteralPath:$html_file_name) -eq $false )
    {
        $(html_top -css_file:(stylesheet_file_name)) >> $html_file_name
    }
}