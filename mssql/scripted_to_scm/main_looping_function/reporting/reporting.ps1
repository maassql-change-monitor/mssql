$my_fullname_reporting_ps1      = ( $MyInvocation.MyCommand.Definition )
$my_dir_reporting_ps1           = ( Split-Path $my_fullname_reporting_ps1 )

. "$($my_dir_reporting_ps1 )\html\html.ps1"
. "$($my_dir_reporting_ps1 )\report_on_completed_batch.ps1"
. "$($my_dir_reporting_ps1 )\report_on_completed_item.ps1"
