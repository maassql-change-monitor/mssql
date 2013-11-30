
<#
TODO:   Change LOGGING to log to a different file every X hours.  DEFAULT = 30 minutes
#>


function scripted_to_scm ()
{
    Set-StrictMode -Version:Latest
    $GLOBAL:ErrorActionPreference               = "Stop"  

    scripted_to_scm_log "scripted_to_scm- BEGIN"

    foreach ( $scripted_db_directory in scripted_db_directories_to_copy )
    {
        scripted_to_scm_log "scripted_to_scm- top of loop.  scripted_db_directory=[$scripted_db_directory]."
        cd $SCRIPT:scripted_db_directory_base_path  <# Just cause there is all of this cd ng around in the rest of the code, reset at the top of this loop #>
        $scrptd = (scripted_db_properties $scripted_db_directory)
        $commit_msg = "InstanceName=[$($scrptd.'instance')].  Db=[$($scrptd.'dbname')].  scripted_to_scm automation. Captured on=[$($scrptd.'dttm')]."
        scripted_to_scm_log "Calling snapshot_commit with a commit msg=[$commit_msg]"
        $null = ( snapshot_commit -local_repository_path:($scrptd.'scm_db_path') -local_snapshot_path:($scrptd.'path') -snapshot_commit_message:$commit_msg -remove_snapshot_path -clear_repository_after_commit )
        scripted_to_scm_log "scripted_to_scm- bottom of loop.  scripted_db_directory=[$scripted_db_directory]."
    }

    if ( ( Test-Path  $SCRIPT:my_exit_loop_flag_file ) -eq $true )
    {
        throw "The flag file for exiting was found.  Throwing error in order to exit process."
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



$error.clear();
Set-StrictMode -Version:Latest
$GLOBAL:ErrorActionPreference               = "Stop"

$my_fullname        = ($MyInvocation.MyCommand.Definition)
if ($my_fullname -eq $null -or $my_fullname -eq "" ) {throw "`$MyInvocation.MyCommand.Definition doesn't work the way I thought it does."}
$my_dir             = ( Split-Path $my_fullname )

. "$($my_fullname).vars.ps1"
. "$($my_dir )\scripted_db_directories_to_copy.ps1"
. "$($my_dir )\scripted_db_properties.ps1"
. "$($my_dir )\scripted_to_scm_log.ps1"
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
import-module -force "C:\DBATools\maassql-change-monitor\mssql\mssql\scripted_to_scm\scripted_to_scm.psm1"
#>

<#
TODO: BUG : If the app is stopped while clearing / deleting a scripted db ( After having committed that DB ), then the app is started again, the app will try to check the db in again, BUT this time, because part of the scripted db has been deleted, it will appear as if parts of the scripted db were dropped from the database.
    Possible Solutions: 
        a) ask repo for the datetime of the last snapshot checked in.  IF the snapshot has already been checked in, delete the scripted db ( snapshot )
        b) Write a lock file in the scripted db.  Delete the lock file as the very last step.  If lock file exists, don't try to check in the scripted db


TODO: FEATURE : Right now, if no changes were made, nothing is being recorded in the GIT repo logs that no changes were observed.  When I've done this before with SVN, I would first insert a tag, then do my adds & commits.
#>