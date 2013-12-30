$my_fullname_main_looping_function_ps1       = ( $MyInvocation.MyCommand.Definition )
$SCRIPT:my_dir_main_looping_function_ps1            = ( Split-Path $my_fullname_main_looping_function_ps1 )

. "$($SCRIPT:my_dir_main_looping_function_ps1 )\loopd_obj.ps1"
. "$($SCRIPT:my_dir_main_looping_function_ps1 )\main_looped_function.ps1"
. "$($SCRIPT:my_dir_main_looping_function_ps1 )\reporting\reporting.ps1"