Function get_error_job ( $process )
{
    $event_receiver = {
        if(-not [string]::IsNullOrEmpty($EventArgs.data)) {
            $frmtd = ( "$($EventArgs.data)" | Out-String )
            ProcessStd "OUTPUT" $frmtd
            write-host "OUTPUT    $frmtd"
        }       
    }

    $errorjob = Register-ObjectEvent -InputObject $process -EventName ErrorDataReceived -SourceIdentifier Common.LaunchProcess.Error -action $event_receiver

    if($errorjob -eq $null) {
        ProcessStd "ERROR" "get_error_job --> the event_receiver's job is null, so no events will be received from stderr."
        Write-Host "ERROR - The error job is null"
    }

    return $errorjob
}