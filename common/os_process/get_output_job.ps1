Function get_output_job ( $process )
{ 
    $event_receiver = {
        if(-not [string]::IsNullOrEmpty($EventArgs.data)) {
            "Out - $($EventArgs.data)" | Out-File ( log_file_name ) -Append
            Write-Host "Out - $($EventArgs.data)"
        }  
    }

    $outputjob = Register-ObjectEvent -InputObject $process -EventName OutputDataReceived -SourceIdentifier Common.LaunchProcess.Output -action $event_receiver

    if($outputjob -eq $null) 
    {
        "ERROR - The output job is null" | Out-File ( log_file_name ) -Encoding ASCII -Append
        Write-Host "ERROR - The output job is null"
    }

    return $outputjob
}