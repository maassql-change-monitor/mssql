# http://stackoverflow.com/questions/16467593/powershell-redirect-executables-stderr-to-file-or-variable-but-still-have-std
# http://stackoverflow.com/users/2586801/romu
<#
.SYNOPSIS
    returns a System.Diagnostics.Process for use with the os_process module
#>
function Create-Process 
    {
        $process = New-Object -TypeName System.Diagnostics.Process
        $process.StartInfo.CreateNoWindow = $false
        $process.StartInfo.RedirectStandardError = $true
        $process.StartInfo.UseShellExecute = $false
        $process.StartInfo.RedirectStandardOutput = $true
        return $process
    }