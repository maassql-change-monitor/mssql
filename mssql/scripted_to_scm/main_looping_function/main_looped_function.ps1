function main_looped_function ()
{
    Set-StrictMode -Version:Latest
    $GLOBAL:ErrorActionPreference               = "Stop"  

    log_this_section "main_looped_function- BEGIN"

    $looped = loopd_obj

    foreach ( $scripted_db_directory in ( $looped.scripted_db_directories_to_copy($SCRIPT:scripted_db_directory_base_path, $SCRIPT:scripted_db_directory_must_sit_idle_for_x_minutes, $SCRIPT:directories_to_grab_at_a_time )))
    {    
        log_this_section "main_looped_function- top of loop.  scripted_db_directory=[$scripted_db_directory]."
        write-host "working on directory = [$scripted_db_directory]"

        if ( $scripted_db_directory -ne $null )
            {
                cd $SCRIPT:scripted_db_directory_base_path
                $scrptd = ($looped.scripted_db_properties( $scripted_db_directory, $SCRIPT:scm_db_script_name, $SCRIPT:scm_db_script_directory_base))
                $commit_msg = (commit_message $scrptd)
                $changes = ( snapshot_commit -snapshot_tag:"$($scrptd.'dttm')" -remove_snapshot_path -clear_repository_after_commit -local_repository_path:($scrptd.'scm_db_path') -local_snapshot_path:($scrptd.'path') -snapshot_commit_message:$commit_msg )
                $null=(item_completed $changes $scrptd)
            }

        exit_if_signaled
    }

    Remove-Variable ("looped") -ErrorAction SilentlyContinue

    batch_completed

    exit_if_signaled

    write-host "about to call the end log_this under main_looped_function"
    log_this "main_looped_function- DONE"    
}