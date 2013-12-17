Function scripted_db_directories_to_copy
{
    $ret_eligible = ( Get-ChildItem -LiteralPath:$SCRIPT:scripted_db_directory_base_path |
        Where-Object { $_.PSIsContainer -eq $true } |
        Where-Object { 
                        $tspan=(New-TimeSpan $_.LastAccessTime (Get-Date));
                        $diff_minutes=($tspan).minutes;
                        return ( $diff_minutes -ge $SCRIPT:scripted_db_directory_must_sit_idle_for_x_minutes ) 
                     }  |
        Select-Object -Property:$_ -First:$SCRIPT:directories_to_grab_at_a_time |
        Where-Object { $_ -ne $null}
                    
        )
    return $ret_eligible
}