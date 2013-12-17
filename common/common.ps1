$error.clear();
Set-StrictMode -Version:Latest
$GLOBAL:ErrorActionPreference               = "Stop"

$my_fullname        = ($MyInvocation.MyCommand.Definition)
if ($my_fullname -eq $null -or $my_fullname -eq "" ) {throw "`$MyInvocation.MyCommand.Definition doesn't work the way I thought it does."}
$my_dir             = ( Split-Path $my_fullname )


. "$($my_dir )\loop_d_loop.ps1"
Import-Module -Force "$($my_dir)\file_system_nuke\file_system_nuke.psm1" <# did you know that?  I did NOT know that!  ."path.psm1" --> actually opens the file.  In my case, in notepad #>
. "$($my_dir )\scm\scm.ps1"
. "$($my_dir )\logger\logger.psm1"