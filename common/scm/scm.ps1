$error.clear();
Set-StrictMode -Version:Latest
$GLOBAL:ErrorActionPreference               = "Stop"

$scm_ps1_fullname        = ($MyInvocation.MyCommand.Definition)
if ($scm_ps1_fullname -eq $null -or $scm_ps1_fullname -eq "" ) {throw "`$MyInvocation.MyCommand.Definition doesn't work the way I thought it does."}
$LOCAL:scm_ps1_my_dir             = ( Split-Path $scm_ps1_fullname )

Set-StrictMode -Version:Latest
$GLOBAL:ErrorActionPreference               = "Stop"

. "$($scm_ps1_fullname).vars.ps1"
. "$($LOCAL:scm_ps1_my_dir)\clear_repository.ps1"
. "$($LOCAL:scm_ps1_my_dir)\commit_to_local_repository.ps1"
. "$($LOCAL:scm_ps1_my_dir)\create_repository.ps1"
. "$($LOCAL:scm_ps1_my_dir)\git_exe.ps1"
. "$($LOCAL:scm_ps1_my_dir)\git_repo_exists.ps1"
. "$($LOCAL:scm_ps1_my_dir)\git_repo_lock_file.ps1"
. "$($LOCAL:scm_ps1_my_dir)\pack_repository.ps1"
. "$($LOCAL:scm_ps1_my_dir)\snapshot_commit.ps1"