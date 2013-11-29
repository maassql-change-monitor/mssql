$here =  ( Split-Path $MyInvocation.MyCommand.Definition )
. "$here\loop_d_loop.ps1"
. "$here\nuke_directory.ps1"
. "$here\scm\scm.ps1"