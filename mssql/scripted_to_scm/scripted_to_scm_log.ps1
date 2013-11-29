Function scripted_to_scm_log ($to_log)
{
    $to_log = "$(Get-Date) | $to_log" 
    $to_log >> $SCRIPT:main_log_file
}