Function scripted_db_directories_to_copy ()
{
    scripted_to_scm_log "scripted_db_directories_to_copy- BEGIN"
    $ret_array = @()
    foreach ( $scripted_dir in Get-ChildItem -LiteralPath:$SCRIPT:scripted_db_directory_base_path `
        | Where-Object { $_.PSIsContainer -eq $true } `
        | Where-Object 
            { 
                $tspan=(New-TimeSpan $scripted_dir.LastAccessTime (Get-Date));
                $diff_minutes=($tspan).minutes;
                return ( $diff_minutes -ge $SCRIPT:scripted_db_directory_must_sit_idle_for_x_minutes ) 
            }  `
        | Select-Object $_ -First:$SCRIPT:directories_to_grab_at_a_time ) <# -Directory is not in 2.0 #>
    {
        $ret_array += $scripted_dir 
    }
    
    scripted_to_scm_log "scripted_db_directories_to_copy -  DONE - Count of directories=[$($ret_array.Count)]"
    return $ret_array
}