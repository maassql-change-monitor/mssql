Function event_receiver_output_data_received
{
    if(-not [string]::IsNullOrEmpty($EventArgs.data)) {
        "Out - $($EventArgs.data)" | Out-File ( log_file_name ) -Encoding ASCII -Append
        Write-Host "Out - $($EventArgs.data)"
    }
}