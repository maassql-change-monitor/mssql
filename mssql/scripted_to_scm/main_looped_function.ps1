function main_looped_function ()
{
    Set-StrictMode -Version:Latest
    $GLOBAL:ErrorActionPreference               = "Stop"  


    log_this ""
    log_this ""
    log_this ""
    log_this "-----------------------------------------------------------------------------------"
    log_this "main_looped_function- BEGIN"

    $looped = loopd_obj

    foreach ( $scripted_db_directory in ( $looped.scripted_db_directories_to_copy($SCRIPT:scripted_db_directory_base_path, $SCRIPT:scripted_db_directory_must_sit_idle_for_x_minutes, $SCRIPT:directories_to_grab_at_a_time )))
    {
        log_this ""
        log_this ""
        log_this ""
        log_this "==================================================================================================="        
        log_this "main_looped_function- top of loop.  scripted_db_directory=[$scripted_db_directory]."
        write-host ""
        write-host ""
        write-host ""
        write-host ""
        write-host "working on directory = [$scripted_db_directory]"

        submit_scripted_db_dir $scripted_db_directory
    
        log_this "main_looped_function- bottom of loop.  scripted_db_directory=[$scripted_db_directory]."

        exit_if_signaled
    }

    Remove-Variable ("looped") -ErrorAction SilentlyContinue

    exit_if_signaled

    write-host "about to call the end log_this under main_looped_function"
    log_this "main_looped_function- DONE"    
}


Function submit_scripted_db_dir ($scripted_db_directory)
{

    if ( $scripted_db_directory -eq $null )
        {
            return $null
        }

    cd $SCRIPT:scripted_db_directory_base_path
    $scrptd = ($looped.scripted_db_properties( $scripted_db_directory, $SCRIPT:scm_db_script_name, $SCRIPT:scm_db_script_directory_base))
    $commit_msg = (commit_message $scrptd)
    $changes = ( snapshot_commit -snapshot_tag:"$($scrptd.'dttm')" -remove_snapshot_path -clear_repository_after_commit -local_repository_path:($scrptd.'scm_db_path') -local_snapshot_path:($scrptd.'path') -snapshot_commit_message:$commit_msg )
    $null=(process_changes $changes $scrptd)
    return $null  
}

function commit_message ($scrptd)
{
   return "Checked_on_$($scrptd.'dttm')"
}

function exit_if_signaled
{
    if ( $SCRIPT:my_exit_loop_flag_file -eq $null -or $SCRIPT:my_exit_loop_flag_file -eq '' ) { throw "CRAP.  `$SCRIPT:my_exit_loop_flag_file is null. or empty string."}
    if ( ( Test-Path  $SCRIPT:my_exit_loop_flag_file ) -eq $true )
    {
        throw "The flag file for exiting was found.  Throwing error in order to exit process."
    }
}

function loopd_obj
{
    $my_dir             = ( Split-Path $my_fullname_scripted_to_scm_psm1 )

    $looped = New-Module { 
        $error.clear();
        Set-StrictMode -Version:Latest
        $GLOBAL:ErrorActionPreference               = "Stop"        

        $path_to_module =  "$($args[0])\looped\looped.psm1"     
        import-module  $path_to_module 
        Export-ModuleMember -Variable * -Function *                
        } -asCustomObject -ArgumentList:@($my_dir)


    return $looped
}