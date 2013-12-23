Function scripted_db_directories_to_copy ( $base_directory , $scripted_db_directory_must_sit_idle_for_x_minutes , $directories_to_grab_at_a_time)
{

    <#
        Only look at directories
        Only look at directories that have not been written to in X minutes
        Sort those directories, oldest written to most recently written 
            ---> the directory name contains the date of the snapshot
            ---> it would be better to grab all of an instances snapshots, to ensure that they are applied in order....
        Select the top X directories ( that have made it this far.... )
        Where the objects are not null? ok...
    #>

    $ret_eligible = ( Get-ChildItem -LiteralPath:$base_directory |
        Where-Object { $_.PSIsContainer -eq $true } |
        Where-Object { 
                        $tspan=(New-TimeSpan $_.LastWriteTimeUtc (Get-Date));
                        $diff_minutes=($tspan).minutes;
                        return ( $diff_minutes -ge $scripted_db_directory_must_sit_idle_for_x_minutes) 
                     }  |
        Sort-Object $_.Name | 
        Select-Object -Property:$_ -First:$directories_to_grab_at_a_time |
        Where-Object { $_ -ne $null}
                    
        )
    return $ret_eligible
}