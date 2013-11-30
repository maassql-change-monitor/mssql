$here =  ( Split-Path $MyInvocation.MyCommand.Definition )
. "$here\loop_d_loop.ps1"
Import-Module -Force "$here\file_system_nuke\file_system_nuke.psm1" <# did you know that?  I did NOT know that!  ."path.psm1" --> actually opens the file.  In my case, in notepad #>
. "$here\scm\scm.ps1"