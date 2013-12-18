function main_looped_function ()
{
    Set-StrictMode -Version:Latest
    $GLOBAL:ErrorActionPreference               = "Stop"  

    scripted_to_scm_log "main_looped_function- BEGIN"




    $looped = New-Module {  
        if ($MyInvocation -eq $null) { throw "myinvoc is null"} 
        write-host $MyInvocation
        write-host $MyInvocation.ToString()
        write-host "$MyInvocation"
        write-host ( $MyInvocation | Format-List )
        $MyInvocation | Format-List 
        write-output ( $MyInvocation | Format-List )
        $var = ( $MyInvocation | Format-List )
        write-host $var
        $my_fullname        = ($MyInvocation.ScriptName       )
        $my_dir             = ( Split-Path $my_fullname )          
        import-module "$($my_dir )\looped\looped.psm1"  
        Export-ModuleMember -Variable * -Function *                
    } -asCustomObject 

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

    write-host "removing the looped psm - bEgIN"
    Remove-Module -Name:"looped"
    write-host "removing the looped psm - DONE"


    if ( ( Test-Path  $SCRIPT:my_exit_loop_flag_file ) -eq $true )
    {
        throw "The flag file for exiting was found.  Throwing error in order to exit process."
    }
    write-host "about to call the end scripted_to_scm_log under main_looped_function"
    scripted_to_scm_log "main_looped_function- DONE"    
}