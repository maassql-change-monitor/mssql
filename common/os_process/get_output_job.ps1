Function get_output_job ( $process )
{ 

    write-host "setting up event receiver in get_output_job.  Is expected to log to:$( log_file_name )"

    $outputjob = Register-ObjectEvent -InputObject $process -EventName OutputDataReceived -SourceIdentifier Common.LaunchProcess.Output -action { event_receiver_output_data_received }

    if($outputjob -eq $null) 
    {
        "ERROR - The output job is null" | Out-File ( log_file_name ) -Encoding ASCII -Append
        Write-Host "ERROR - The output job is null"
    }

    return $outputjob
}

