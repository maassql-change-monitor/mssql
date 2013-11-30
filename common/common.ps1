$here =  ( Split-Path $MyInvocation.MyCommand.Definition )
. "$here\loop_d_loop.ps1"
. "$here\file_system_nuke\file_system_nuke.psm1"
. "$here\scm\scm.ps1"