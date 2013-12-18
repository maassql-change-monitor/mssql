# http://stackoverflow.com/questions/16467593/powershell-redirect-executables-stderr-to-file-or-variable-but-still-have-std
# http://stackoverflow.com/users/2586801/romu
function Terminate-Process {
    param([System.Diagnostics.Process]$process)

    $code = $process.ExitCode
    $process.Close()
    $process.Dispose()
    Remove-Variable process
    return $code
}