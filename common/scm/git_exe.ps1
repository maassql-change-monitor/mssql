
Function git_exe ($path_to_repository, $da_args, $quiet)
{
    $si = New-Object System.Diagnostics.ProcessStartInfo
    $si.Arguments = $da_args
    $si.UseShellExecute = $false
    $si.RedirectStandardOutput = $true
    $si.RedirectStandardError = $true
    $si.WorkingDirectory = $path_to_repository
    $si.FileName = $SCRIPT:git_path
    $process = [Diagnostics.Process]::Start($si)
    while (!($process.HasExited))
    {
        // do what you want with strerr and stdout
        Start-Sleep -s 1  // sleep for 1s
    }

    $out = $process.StandardOutput.ReadToEnd()
    $err = $process.StandardError.ReadToEnd()

    if ($quiet -ne $true)
    {
      write-host "----------std-out-------------------------------------"
      write-host $out
      write-host "----------std-err-------------------------------------"
      write-host $err
    }
    
}

