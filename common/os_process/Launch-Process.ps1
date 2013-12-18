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

        unregister_events

        $outputjob = get_output_job $process
        $errorjob = get_error_job $process

        try 
        {
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

            $events_failed = $false

            $out_job_info = (  $outputjob | Format-List | Out-String )
            if ( $outputjob.JobStateInfo.State -eq 'Failed' ) { $events_failed = $true } 
            scripted_to_scm_log "PROCESS STD OUTPUT=[
$out_job_info
]"

            $err_job_info = (  $errorjob | Format-List | Out-String )   
            if ( $errorjob.JobStateInfo.State -eq 'Failed' ) { $events_failed = $true }
            scripted_to_scm_log "PROCESS STD ERROR OUTPUT=[
$err_job_info 
]"

            if ($events_failed -eq $true)
            {
                throw "Events failed.  
                
                `$err_job_info  = [$err_job_info]

                `$out_job_info  = [$out_job_info]
                "
            }          
        }
        finally
        {

            unregister_events
            
            Stop-Job $errorjob.Id
            Remove-Job $errorjob.Id
            
            Stop-Job $outputjob.Id
            Remove-Job $outputjob.Id 
        }

        write-host "Launch-Process--------DONE-------------------"

        $ret
    }   


function unregister_events
{
            # Cancel the event registrations
            Remove-Event -SourceIdentifier Common.LaunchProcess.Error -ErrorAction SilentlyContinue
            Remove-Event -SourceIdentifier Common.LaunchProcess.Output -ErrorAction SilentlyContinue

            Unregister-Event -SourceIdentifier Common.LaunchProcess.Error -ErrorAction SilentlyContinue
            Unregister-Event -SourceIdentifier Common.LaunchProcess.Output -ErrorAction SilentlyContinue
}