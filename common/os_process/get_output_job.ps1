Function get_output_job ( $process )
{ 

    write-host "setting up event receiver in get_output_job.  Is expected to log to:$( log_file_name )"

    $event_receiver = {
        write-host "event_receiver_output_data_received-------BEGIN-------------------"
        if(-not [string]::IsNullOrEmpty($EventArgs.data)) {
            "Out - $($EventArgs.data)" | Out-File ( log_file_name ) -Append
            Write-Host "Out - $($EventArgs.data)"
        }
        write-host "event_receiver_output_data_received-------DONE-------------------"    
    }



    $outputjob = Register-ObjectEvent -InputObject $process -EventName OutputDataReceived -SourceIdentifier Common.LaunchProcess.Output -action $event_receiver

    if($outputjob -eq $null) 
    {
        "ERROR - The output job is null" | Out-File ( log_file_name ) -Encoding ASCII -Append
        Write-Host "ERROR - The output job is null"
    }

    return $outputjob
}