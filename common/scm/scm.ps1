$here =  ( Split-Path $MyInvocation.MyCommand.Definition )
Set-StrictMode -Version:Latest
$GLOBAL:ErrorActionPreference               = "Stop"

. "$($MyInvocation.MyCommand.Definition).vars.ps1"
. "$here\clear_repository.ps1"
. "$here\commit_to_local_repository.ps1"
. "$here\create_repository.ps1"
. "$here\pack_repository.ps1"
. "$here\snapshot_commit.ps1"