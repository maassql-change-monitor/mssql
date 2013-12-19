Function get_error_job ( $process )
{
    $event_receiver = {
        if(-not [string]::IsNullOrEmpty($EventArgs.data)) {
            "ERROR - $($EventArgs.data)" | Out-File ( log_file_name ) -Append
            # Write-Host "ERROR - $($EventArgs.data)"
        }       
    }

    $errorjob = Register-ObjectEvent -InputObject $process -EventName ErrorDataReceived -SourceIdentifier Common.LaunchProcess.Error -action $event_receiver

    if($errorjob -eq $null) {
        "ERROR - The error job is null" | Out-File ( log_file_name ) -Encoding ASCII -Append
        Write-Host "ERROR - The error job is null"
    }

    return $errorjob
}