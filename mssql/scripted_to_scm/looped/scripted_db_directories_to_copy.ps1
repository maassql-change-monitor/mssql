Function scripted_db_directories_to_copy ( $base_directory , $scripted_db_directory_must_sit_idle_for_x_minutes , $directories_to_grab_at_a_time)
{
    $ret_eligible = ( Get-ChildItem -LiteralPath:$base_directory |
        Where-Object { $_.PSIsContainer -eq $true } |
        Where-Object { 
                        $tspan=(New-TimeSpan $_.LastAccessTime (Get-Date));
                        $diff_minutes=($tspan).minutes;
                        return ( $diff_minutes -ge $scripted_db_directory_must_sit_idle_for_x_minutes) 
                     }  |
        Select-Object -Property:$_ -First:$directories_to_grab_at_a_time |
        Where-Object { $_ -ne $null}
                    
        )
    return $ret_eligible
}