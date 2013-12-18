function event_receiver_error_data_received
{
    write-host "event_receiver_error_data_received-------BEGIN-------------------"
    if(-not [string]::IsNullOrEmpty($EventArgs.data)) {
        "ERROR - $($EventArgs.data)" | Out-File ( log_file_name ) -Encoding ASCII -Append
        Write-Host "ERROR - $($EventArgs.data)"
    }
    write-host "event_receiver_error_data_received-------END-------------------"    
}