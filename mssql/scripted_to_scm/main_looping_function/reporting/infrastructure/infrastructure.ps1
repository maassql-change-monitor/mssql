$my_fullname_html_ps1     = ( $MyInvocation.MyCommand.Definition )
$my_dir_html_ps1          = ( Split-Path $my_fullname_html_ps1   )

. "$($my_dir_html_ps1 )\check_for_changes_html.ps1"
. "$($my_dir_html_ps1 )\html_file_names.ps1"
. "$($my_dir_html_ps1 )\git_web_url_base.ps1"
. "$($my_dir_html_ps1 )\url_last_change.ps1"
. "$($my_dir_html_ps1 )\web_server_url.ps1"
. "$($my_dir_html_ps1 )\write_status.ps1"

