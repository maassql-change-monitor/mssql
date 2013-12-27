$my_fullname_main_looping_function_ps1       = ( $MyInvocation.MyCommand.Definition )
$my_dir_main_looping_function_ps1            = ( Split-Path $my_fullname_main_looping_function_ps1 )

. "$($my_dir_main_looping_function_ps1 )\loopd_obj.ps1"
. "$($my_dir_main_looping_function_ps1 )\main_looped_function.ps1"
. "$($my_dir_main_looping_function_ps1 )\reporting\reporting.ps1"
. "$($my_dir_main_looping_function_ps1 )\perform_snapshot_commit_of_scripted_db_directory.ps1"