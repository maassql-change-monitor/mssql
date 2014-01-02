$my_fullname_file_system_ps1       = ($MyInvocation.MyCommand.Definition)
$my_dir_file_system_ps1            = ( Split-Path $my_fullname_file_system_ps1 )

Import-Module -Force "$($my_dir_file_system_ps1)\nuke\nuke.psm1" <# did you know that?  I did NOT know that!  ."path.psm1" --> actually opens the file.  In my case, in notepad #>
. "$($my_dir_file_system_ps1)\shared_write_to_common_file.ps1"
. "$($my_dir_file_system_ps1)\write_safe.ps1"