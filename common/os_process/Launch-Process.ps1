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
            $process.Start() 
            $process.BeginErrorReadLine()
            if($process.StartInfo.RedirectStandardOutput) { $process.BeginOutputReadLine() }

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
                    Write-Warning "ERROR - The process is not completed, after the specified timeout: $($timeout)"
                    $ret = $false
                }
                else
                {
                    write-host "recording process exit information"
                    $null=(ProcessStd "START Time" $process.StartTime )
                    $null=(ProcessStd "EXIT CODE" $process.ExitCode ) 
                    $null=(ProcessStd "EXIT Time" $process.ExitTime )
                    $null=(ProcessStd "TOTAL PROCESSOR TIME" $process.TotalProcessorTime )
                    $null=(ProcessStd "TOTAL USERPROCESSOR TIME" $process.UserProcessorTime )

                    $ret = $true
                }
            }
        }
        finally
        {
            $null = ( check_events $outputjob $errorjob )   
        }

        
        return $ret
    }   

function check_events ( $outputjob, $errorjob)
{
    try 
        {
            $events_failed = $false

            $out_job_info = (  $outputjob | Format-List | Out-String )
            if ( $outputjob.JobStateInfo.State -eq 'Failed' ) { $events_failed = $true } 

            $err_job_info = (  $errorjob | Format-List | Out-String )   
            if ( $errorjob.JobStateInfo.State -eq 'Failed' ) { $events_failed = $true }


            if ($events_failed -eq $true)
            {

            log_this "PROCESS STD OUTPUT=[
$out_job_info
]"
            log_this "PROCESS STD ERROR OUTPUT=[
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
    return $null
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