$error.clear();
Set-StrictMode -Version:Latest
$GLOBAL:ErrorActionPreference               = "Stop"

$common_ps1_fullname        = ($MyInvocation.MyCommand.Definition)
if ($common_ps1_fullname -eq $null -or $common_ps1_fullname -eq "" ) {throw "`$MyInvocation.MyCommand.Definition doesn't work the way I thought it does."}
$LOCAL:common_ps1_my_dir             = ( Split-Path $common_ps1_fullname )

Import-Module -Force "$($LOCAL:common_ps1_my_dir)\file_system_nuke\file_system_nuke.psm1" <# did you know that?  I did NOT know that!  ."path.psm1" --> actually opens the file.  In my case, in notepad #>
Import-Module -Force "$($LOCAL:common_ps1_my_dir )\logger\logger.psm1"
. "$($LOCAL:common_ps1_my_dir )\loop_d_loop\loop_d_loop.ps1"
. "$($LOCAL:common_ps1_my_dir )\os_process\os_process.ps1"
. "$($LOCAL:common_ps1_my_dir )\scm\scm.ps1"