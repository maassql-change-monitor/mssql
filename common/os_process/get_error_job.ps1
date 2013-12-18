Function get_error_job ( $process )
{
    write-host "setting up event receiver in get_output_job.  Is expected to log to:$( log_file_name )"

    $errorjob = Register-ObjectEvent -InputObject $process -EventName ErrorDataReceived -SourceIdentifier Common.LaunchProcess.Error -action { GLOBAL:event_receiver_error_data_received }

    if($errorjob -eq $null) {
        "ERROR - The error job is null" | Out-File ( log_file_name ) -Encoding ASCII -Append
        Write-Host "ERROR - The error job is null"
    }

    return $errorjob
}