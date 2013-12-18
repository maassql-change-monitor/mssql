Function GLOBAL:event_receiver_output_data_received
{
    write-host "event_receiver_output_data_received-------BEGIN-------------------"
    if(-not [string]::IsNullOrEmpty($EventArgs.data)) {
        "Out - $($EventArgs.data)" | Out-File ( log_file_name ) -Encoding ASCII -Append
        Write-Host "Out - $($EventArgs.data)"
    }
    write-host "event_receiver_output_data_received-------DONE-------------------"    
}