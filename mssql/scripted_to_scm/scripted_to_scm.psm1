
<#
TODO:   Change LOGGING to log to a different file every X hours.  DEFAULT = 30 minutes
#>


function scripted_to_scm ()
{
    $error.clear();
    Set-StrictMode -Version:Latest
    $GLOBAL:ErrorActionPreference               = "Stop"  

    scripted_to_scm_log "scripted_to_scm- BEGIN"

    foreach ( $scripted_db_directory in scripted_db_directories_to_copy )
    {
        scripted_to_scm_log "scripted_to_scm- top of loop.  scripted_db_directory=[$scripted_db_directory]."
        cd $SCRIPT:scripted_db_directory_base_path  <# Just cause there is all of this cd ng around in the rest of the code, reset at the top of this loop #>
        $scrptd = (scripted_db_properties $scripted_db_directory)
        $commit_msg = "InstanceName=[$($scrptd.'instance')].  Db=[$($scrptd.'dbname')].  scripted_to_scm automation. Captured on=[$($scrptd.'dttm')]."
        $null = ( snapshot_commit -local_repository_path:($ret_hash.'scm_db_path') -local_snapshot_path:($scrptd.'path') -snapshot_commit_message:$commit_msg -remove_snapshot_path -clear_repository_after_commit )
        scripted_to_scm_log "scripted_to_scm- bottom of loop.  scripted_db_directory=[$scripted_db_directory]."
    }

    scripted_to_scm_log "scripted_to_scm- DONE"    
}

function synch_loop ()
{
    Set-StrictMode -Version:Latest
    $GLOBAL:ErrorActionPreference               = "Stop"
    $sb = {scripted_to_scm}
    $SCRIPT:dbs_put_into_scm = 0
    loop_your_code -hours_to_run:$SCRIPT:stop_the_script_after_X_hours -seconds_to_pause:$SCRIPT:synch_every_X_seconds -code_block_to_invoke:$sb
}



$here =  ( Split-Path $MyInvocation.MyCommand.Definition )
$error.clear();
Set-StrictMode -Version:Latest
$GLOBAL:ErrorActionPreference               = "Stop"

. "$($MyInvocation.MyCommand.Definition).vars.ps1"
. "$here\scripted_db_directories_to_copy.ps1"
. "$here\scripted_db_properties.ps1"
. "$here\scripted_to_scm_log.ps1"
. "$SCRIPT:code_common_directory\common.ps1"

# MAIN code......
try 
{
    scripted_to_scm_log "scripted_to_scm - main body - BEGIN"
    synch_loop  
    scripted_to_scm_log "scripted_to_scm - main body - out of synch_loop" 
}
catch [Exception]
{
    scripted_to_scm_log "scripted_to_scm - main body - error occurred $_"
    write-error $_   
}
finally
{
    scripted_to_scm_log "scripted_to_scm - main body - DONE"
}


<#
import-module -force F:\scm_databases\code\scripted_to_scm
#>