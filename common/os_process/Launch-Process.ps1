# http://stackoverflow.com/questions/16467593/powershell-redirect-executables-stderr-to-file-or-variable-but-still-have-std
# http://stackoverflow.com/users/2586801/romu
function Launch-Process 
    {
        param
            (
                [System.Diagnostics.Process]        $process
                , [int]                             $timeout = 0
            )

        $GLOBAL:stream = ""

        unregister_events

        $outputjob = get_output_job $process
        $errorjob = get_error_job $process

        try 
        {
            write-host "launching process in "
            write-host (pwd)

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
                    ProcessStd "START Time" $process.StartTime
                    ProcessStd "EXIT CODE" $process.ExitCode 
                    ProcessStd "EXIT Time" $process.ExitTime
                    ProcessStd "TOTAL PROCESSOR TIME" $process.TotalProcessorTime
                    ProcessStd "TOTAL USERPROCESSOR TIME" $process.UserProcessorTime

                    $ret = $true
                }
            }

            $events_failed = $false

            $out_job_info = (  $outputjob | Format-List | Out-String )
            if ( $outputjob.JobStateInfo.State -eq 'Failed' ) { $events_failed = $true } 

            $err_job_info = (  $errorjob | Format-List | Out-String )   
            if ( $errorjob.JobStateInfo.State -eq 'Failed' ) { $events_failed = $true }


            if ($events_failed -eq $true)
            {

            scripted_to_scm_log "PROCESS STD OUTPUT=[
$out_job_info
]"
            scripted_to_scm_log "PROCESS STD ERROR OUTPUT=[
$err_job_info 
]"                
                throw "Events failed.  
                
                `$err_job_info  = [$err_job_info]

                `$out_job_info  = [$out_job_info]
                "
            }          
        }
        finally
        {

            unregister_events
            
            $null = ( Stop-Job $errorjob.Id )
            $null = ( Remove-Job $errorjob.Id )
            
            $null = (Stop-Job $outputjob.Id )
            $null = (Remove-Job $outputjob.Id )
        }
        
        return $ret
    }   


function unregister_events
{
    # Cancel the event registrations
    Remove-Event -SourceIdentifier Common.LaunchProcess.Error -ErrorAction SilentlyContinue
    Remove-Event -SourceIdentifier Common.LaunchProcess.Output -ErrorAction SilentlyContinue

    Unregister-Event -SourceIdentifier Common.LaunchProcess.Error -ErrorAction SilentlyContinue
    Unregister-Event -SourceIdentifier Common.LaunchProcess.Output -ErrorAction SilentlyContinue


    return $null
}