$my_fullname_infrastructure_ps1     = ( $MyInvocation.MyCommand.Definition )
$my_dir_infrastructure_ps1          = ( Split-Path $my_fullname_infrastructure_ps1  )

. "$($my_dir_infrastructure_ps1 )\git_web_url_base.ps1"
. "$($my_dir_infrastructure_ps1 )\git_web_url_last_change.ps1"
. "$($my_dir_infrastructure_ps1 )\html_file_names.ps1"
. "$($my_dir_infrastructure_ps1 )\schema_checkin_as_html.ps1"
. "$($my_dir_infrastructure_ps1 )\setup_html_file.ps1"
. "$($my_dir_infrastructure_ps1 )\web_server_url.ps1"