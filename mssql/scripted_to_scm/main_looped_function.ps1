function main_looped_function ()
{
    Set-StrictMode -Version:Latest
    $GLOBAL:ErrorActionPreference               = "Stop"  

    scripted_to_scm_log "scripted_to_scm- BEGIN"

    $my_fullname        = ($MyInvocation.MyCommand.Definition)
    $my_dir             = ( Split-Path $my_fullname )
    [string]$loop_module= "$($my_dir )\looped\looped.psm1"
    import-module -Force -Name:$loop_module 
    

    foreach ( $scripted_db_directory in scripted_db_directories_to_copy )
    {
        scripted_to_scm_log "scripted_to_scm- top of loop.  scripted_db_directory=[$scripted_db_directory]."

        if ( $scripted_db_directory -ne $null )
        {
            cd $SCRIPT:scripted_db_directory_base_path  <# Just cause there is all of this cd ng around in the rest of the code, reset at the top of this loop #>
            $scrptd = (scripted_db_properties $scripted_db_directory)
            $commit_msg = "InstanceName=[$($scrptd.'instance')].  Db=[$($scrptd.'dbname')].  scripted_to_scm automation. Captured on=[$($scrptd.'dttm')]."
            scripted_to_scm_log "Calling snapshot_commit -remove_snapshot_path -clear_repository_after_commit -local_repository_path:$($scrptd.'scm_db_path') -local_snapshot_path:$($scrptd.'path') -snapshot_commit_message:$commit_msg "
            $null = ( snapshot_commit -remove_snapshot_path -clear_repository_after_commit -local_repository_path:($scrptd.'scm_db_path') -local_snapshot_path:($scrptd.'path') -snapshot_commit_message:$commit_msg )
        }

        scripted_to_scm_log "scripted_to_scm- bottom of loop.  scripted_db_directory=[$scripted_db_directory]."
    }


    Remove-Module -Force -Name:$loop_module 

    if ( ( Test-Path  $SCRIPT:my_exit_loop_flag_file ) -eq $true )
    {
        throw "The flag file for exiting was found.  Throwing error in order to exit process."
    }

    scripted_to_scm_log "scripted_to_scm- DONE"    
}