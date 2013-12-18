function main_looped_function ()
{
    Set-StrictMode -Version:Latest
    $GLOBAL:ErrorActionPreference               = "Stop"  

    scripted_to_scm_log "main_looped_function- BEGIN"

    $looped = loopd_obj

    foreach ( $scripted_db_directory in ( $looped.scripted_db_directories_to_copy($SCRIPT:scripted_db_directory_base_path, $SCRIPT:scripted_db_directory_must_sit_idle_for_x_minutes, $SCRIPT:directories_to_grab_at_a_time )))
    {
        scripted_to_scm_log "main_looped_function- top of loop.  scripted_db_directory=[$scripted_db_directory]."

        if ( $scripted_db_directory -ne $null )
        {
            cd $SCRIPT:scripted_db_directory_base_path
            $scrptd = ($looped.scripted_db_properties( $scripted_db_directory, $SCRIPT:scm_db_script_name, $SCRIPT:scm_db_script_directory_base))
            $commit_msg = "InstanceName=[$($scrptd.'instance')].  Db=[$($scrptd.'dbname')].  main_looped_function automation. Captured on=[$($scrptd.'dttm')]."
            scripted_to_scm_log "Calling snapshot_commit -remove_snapshot_path -clear_repository_after_commit -local_repository_path:$($scrptd.'scm_db_path') -local_snapshot_path:$($scrptd.'path') -snapshot_commit_message:$commit_msg "
            $null = ( snapshot_commit -remove_snapshot_path -clear_repository_after_commit -local_repository_path:($scrptd.'scm_db_path') -local_snapshot_path:($scrptd.'path') -snapshot_commit_message:$commit_msg )
        }

        scripted_to_scm_log "main_looped_function- bottom of loop.  scripted_db_directory=[$scripted_db_directory]."
    }

    Remove-Variable ("looped") -ErrorAction SilentlyContinue

    if ( ( Test-Path  $SCRIPT:my_exit_loop_flag_file ) -eq $true )
    {
        throw "The flag file for exiting was found.  Throwing error in order to exit process."
    }
    write-host "about to call the end scripted_to_scm_log under main_looped_function"
    scripted_to_scm_log "main_looped_function- DONE"    
}

function loopd_obj
{
    $my_dir             = ( Split-Path $my_fullname )

    $looped = New-Module { 
        $error.clear();
        Set-StrictMode -Version:Latest
        $GLOBAL:ErrorActionPreference               = "Stop"        

        $path_to_module =  "$($args[0])\looped\looped.psm1"
        write-host "path to module=[$path_to_module]"      
        import-module  $path_to_module 
        Export-ModuleMember -Variable * -Function *                
        } -asCustomObject -ArgumentList:@($my_dir)


    return $looped
}