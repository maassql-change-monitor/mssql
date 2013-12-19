Function GLOBAL:scripted_to_scm_log ($to_log)
{
    $to_log = "$(Get-Date) | $to_log" 
    $to_log >> (log_file_name)
}