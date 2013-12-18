function event_receiver_error_data_received
{
    if(-not [string]::IsNullOrEmpty($EventArgs.data)) {
        "ERROR - $($EventArgs.data)" | Out-File ( log_file_name ) -Encoding ASCII -Append
        Write-Host "ERROR - $($EventArgs.data)"
    }
}