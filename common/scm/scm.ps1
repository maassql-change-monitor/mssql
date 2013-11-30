$error.clear();
Set-StrictMode -Version:Latest
$GLOBAL:ErrorActionPreference               = "Stop"

$my_fullname        = ($MyInvocation.MyCommand.Definition)
if ($my_fullname -eq $null -or $my_fullname -eq "" ) {throw "`$MyInvocation.MyCommand.Definition doesn't work the way I thought it does."}
$my_dir             = ( Split-Path $my_fullname )

Set-StrictMode -Version:Latest
$GLOBAL:ErrorActionPreference               = "Stop"

. "$($MyInvocation.MyCommand.Definition).vars.ps1"
. "$($my_dir)\clear_repository.ps1"
. "$($my_dir)\commit_to_local_repository.ps1"
. "$($my_dir)\create_repository.ps1"
. "$($my_dir)\pack_repository.ps1"
. "$($my_dir)\snapshot_commit.ps1"