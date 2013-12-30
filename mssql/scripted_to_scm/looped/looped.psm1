$error.clear();
Set-StrictMode -Version:Latest
$GLOBAL:ErrorActionPreference               = "Stop"

$my_fullname_looped_psm1        = ($MyInvocation.MyCommand.Definition)
$my_dir_looped_psm1             = ( Split-Path $my_fullname_looped_psm1 )

$code_common_directory=( Resolve-Path "$my_dir_looped_psm1\..\..\..\common" )

. "$($my_dir_looped_psm1 )\html_file_names.ps1"
. "$($my_dir_looped_psm1 )\scripted_db_directories_to_copy.ps1"
. "$($my_dir_looped_psm1 )\scripted_db_properties.ps1"
. "$($code_common_directory)\common.ps1"