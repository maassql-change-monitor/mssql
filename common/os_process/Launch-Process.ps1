# http://stackoverflow.com/questions/16467593/powershell-redirect-executables-stderr-to-file-or-variable-but-still-have-std
# http://stackoverflow.com/users/2586801/romu
function Launch-Process 
    {
        param
            (
                [System.Diagnostics.Process]        $process
                , [int]                             $timeout = 0
            )

        write-host "Launch-Process--------BEGIN-----------------------"

        Remove-Event -SourceIdentifier Common.LaunchProcess.Error -ErrorAction SilentlyContinue
        Remove-Event -SourceIdentifier Common.LaunchProcess.Output -ErrorAction SilentlyContinue

        Unregister-Event -SourceIdentifier Common.LaunchProcess.Error -ErrorAction SilentlyContinue
        Unregister-Event -SourceIdentifier Common.LaunchProcess.Output -ErrorAction SilentlyContinue



        $outputjob = get_output_job $process
        $errorjob = get_error_job $process

        write-host "OutputJob info:"
        write-host (  $outputjob | Format-List | Out-String )

        write-host "ErrorJob info:"
        write-host (  $errorjob | Format-List | Out-String )

        try {
            write-host "passing in the job"
            Start-Job $outputjob
            Start-Job $errorjob
        }
        catch {
            try 
            {
                write-host "passing in the name to def name"
                Start-Job -DefinitionName:$outputjob.Name
                Start-Job -DefinitionName:$errorjob.Name
            }
            catch [Exception]
            {
                write-host "passing in just the name"
                Start-Job $outputjob.Name
                Start-Job $errorjob.Name
            }

        }





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


        write-host "Launch-Process--------DONE-------------------"

        $ret
    }   