$error.clear();
Set-StrictMode -Version:Latest
$GLOBAL:ErrorActionPreference               = "Stop"

$my_fullname        = ( $MyInvocation.MyCommand.Definition )
$my_dir             = ( Split-Path $my_fullname )
$SCRIPT:Log_directory = $my_dir 

. "$($my_dir )\get_sortable_date_hour.ps1"
. "$($my_dir )\log_file_name.ps1"
. "$($my_dir )\log_me_as.ps1"
. "$($my_dir )\log_this.ps1"
. "$($my_dir )\..\file_system\file_system.ps1"

$GLOBAL:log_me_as_logger_name = 'log_this'