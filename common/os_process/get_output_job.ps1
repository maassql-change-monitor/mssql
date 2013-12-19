Function get_output_job ( $process )
{ 
    $event_receiver = {
        if(-not [string]::IsNullOrEmpty($EventArgs.data)) {
            $frmtd = ( "$($EventArgs.data)" | Out-String )
            ProcessStd "ERROR" $frmtd
        }  
    }

    $outputjob = Register-ObjectEvent -InputObject $process -EventName OutputDataReceived -SourceIdentifier Common.LaunchProcess.Output -action $event_receiver

    if($outputjob -eq $null) 
    {
        ProcessStd "ERROR" "get_output_job --> the event_receiver's job is null, so no events will be received from stdout."
        Write-Host "ERROR - The output job is null"
    }

    return $outputjob
}