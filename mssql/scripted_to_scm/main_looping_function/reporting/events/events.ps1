$my_fullname_events_ps1      = ( $MyInvocation.MyCommand.Definition )
$my_dir_events_ps1           = ( Split-Path $my_fullname_events_ps1 )

. "$($my_dir_events_ps1 )\batch_completed.ps1"
. "$($my_dir_events_ps1 )\item_completed.ps1"
. "$($my_dir_events_ps1 )\change_detected.ps1"