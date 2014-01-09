Function GLOBAL:log_this ($to_log, $log_name=$null)
{
    $to_log = "$(Get-Date) | $to_log" 
    $null = ( shared_write_to_common_file (log_file_name $log_name) $to_log )
}