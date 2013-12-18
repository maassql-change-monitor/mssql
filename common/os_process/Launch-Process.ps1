# http://stackoverflow.com/questions/16467593/powershell-redirect-executables-stderr-to-file-or-variable-but-still-have-std
# http://stackoverflow.com/users/2586801/romu
function Launch-Process 
    {
        param
            (
                [System.Diagnostics.Process]        $process
                , [int]                             $timeout = 0
            )


        $outputjob = get_output_job $process
        $errorjob = get_error_job $process

        $process.Start() 
        $process.BeginErrorReadLine()

        if($process.StartInfo.RedirectStandardOutput) {
            $process.BeginOutputReadLine() 
        }

        $ret = $null
        if($timeout -eq 0)
        {
            $process.WaitForExit()
            $ret = $true
        }
        else
        {
            if(-not($process.WaitForExit($timeout)))
            {
                Write-Host "ERROR - The process is not completed, after the specified timeout: $($timeout)"
                $ret = $false
            }
            else
            {
                $ret = $true
            }
        }

        # Cancel the event registrations
        Remove-Event -SourceIdentifier Common.LaunchProcess.Error -ErrorAction SilentlyContinue
        Remove-Event -SourceIdentifier Common.LaunchProcess.Output -ErrorAction SilentlyContinue

        Unregister-Event -SourceIdentifier Common.LaunchProcess.Error
        Unregister-Event -SourceIdentifier Common.LaunchProcess.Output

        Stop-Job $errorjob.Id
        Remove-Job $errorjob.Id
        
        Stop-Job $outputjob.Id
        Remove-Job $outputjob.Id

        $ret
    }   