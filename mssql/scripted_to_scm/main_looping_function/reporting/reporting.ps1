$my_fullname_reporting_ps1      = ( $MyInvocation.MyCommand.Definition )
$my_dir_reporting_ps1           = ( Split-Path $my_fullname_reporting_ps1 )

. "$($my_dir_reporting_ps1 )\events\events.ps1"
. "$($my_dir_reporting_ps1 )\infrastructure\infrastructure.ps1"