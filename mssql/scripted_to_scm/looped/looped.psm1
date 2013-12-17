$error.clear();
Set-StrictMode -Version:Latest
$GLOBAL:ErrorActionPreference               = "Stop"

$my_fullname        = ($MyInvocation.MyCommand.Definition)
$my_dir             = ( Split-Path $my_fullname )

code_common_directory=( Resolve-Path "$my_dir\..\..\..\common" )

. "$($my_dir )\scripted_db_directories_to_copy.ps1"
. "$($my_dir )\scripted_db_properties.ps1"
. "$(code_common_directory)\common.ps1"