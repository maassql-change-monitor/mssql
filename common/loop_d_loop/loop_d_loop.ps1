$error.clear();
Set-StrictMode -Version:Latest
$GLOBAL:ErrorActionPreference               = "Stop"

$loop_d_loop_ps1_fullname        = ($MyInvocation.MyCommand.Definition)
if ($loop_d_loop_ps1_fullname -eq $null -or $loop_d_loop_ps1_fullname -eq "" ) {throw "`$MyInvocation.MyCommand.Definition doesn't work the way I thought it does."}
$LOCAL:loop_d_loop_ps1_my_dir             = ( Split-Path $loop_d_loop_ps1_fullname )

. "$($LOCAL:loop_d_loop_ps1_my_dir )/loop_status.ps1"
. "$($LOCAL:loop_d_loop_ps1_my_dir )/loop_your_code.ps1"
. "$($LOCAL:loop_d_loop_ps1_my_dir )/pause_loop.ps1"