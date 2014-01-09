Function get_error_job ( $process )
{
    $event_receiver = {
        if(-not [string]::IsNullOrEmpty($EventArgs.data)) {
            $frmtd = ( "$($EventArgs.data)" | Out-String )
            ProcessStd "ERROR" $frmtd
        }       
    }

    $errorjob = Register-ObjectEvent -InputObject $process -EventName ErrorDataReceived -SourceIdentifier Common.LaunchProcess.Error -action $event_receiver

    if($errorjob -eq $null) 
    {
        $desc = "get_error_job --> the event_receiver's job is null, so no events will be received from stderr."
        log_this $desc 'os_process'
        ProcessStd "ERROR" $desc
        Write-Warning "ERROR - The error job is null.  $desc"
    }

    return $errorjob
}