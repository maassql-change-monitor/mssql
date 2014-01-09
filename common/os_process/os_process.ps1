
<#
.SYNOPSIS
    * http://stackoverflow.com/questions/16467593/powershell-redirect-executables-stderr-to-file-or-variable-but-still-have-std
    * http://stackoverflow.com/users/2586801/romu

.EXAMPLE
    $dir = <your dir>
    $repo = <your repo>

    $executable_path_n_name = "git.exe"
    $single_argument_string = "clone $($repo)"
    $working_directory = $dir

    $ret_val = ( run_process $executable_name $arguments  $working_directory  )

    write-host "running git return val=[$ret_val]."
    $content = Get-Content ( log_file_name ) | Out-String

    write-host "std_out and std_err :"
    write-host $content
#>

Set-StrictMode -Version:Latest
$GLOBAL:ErrorActionPreference               = "Stop"

$os_process_ps1_fullname                    = ($MyInvocation.MyCommand.Definition)
$os_process_ps1_my_dir                = ( Split-Path $os_process_ps1_fullname )



. "$($os_process_ps1_my_dir)\Create-Process.ps1"
. "$($os_process_ps1_my_dir)\Launch-Process\Launch-Process.ps1"
. "$($os_process_ps1_my_dir)\run_process.ps1"
. "$($os_process_ps1_my_dir)\Terminate-Process.ps1"


