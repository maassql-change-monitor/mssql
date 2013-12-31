Function GLOBAL:log_this ($to_log)
{
    $to_log = "$(Get-Date) | $to_log" 
    $to_log >> (log_file_name)
}