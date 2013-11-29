
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

        cd $SCRIPT:scripted_db_directory

        $folder_name = $scripted_db_directory.Name 
        $split_up = $folder_name.Split("!")
        if ( $split_up.Count -ne 4 )
        {
            $err_msg = "The scripted_db_directory we received did not follow our naming conventions.... directory we received=[$($scripted_db_directory.FullName)].  split_up.Count=[$($split_up.Count)]"
            scripted_to_scm_log "scripted_to_scm - $err_msg..........$split_up"
            throw $err_msg
        }

        #parse the variables from the scripted_db_directory
        $server_n_instance = ($split_up[0]).TrimEnd('_')
        $database_name = ($split_up[1]).TrimEnd('_').TrimStart('_')
        $captured_on = ($split_up[2]).TrimEnd('_').TrimStart('_')

        #construct the scm Path
        $scm_db_path = ($SCRIPT:scm_db_script_directory_template).Replace('{base}', $SCRIPT:scm_db_script_directory_base).Replace("{server_instance}", $server_n_instance).Replace("{database}", $database_name)

        scripted_to_scm_log "`$server_n_instance                     =[$server_n_instance]"
        scripted_to_scm_log "`$database_name                         =[$database_name]"
        scripted_to_scm_log "`$captured_on                           =[$captured_on]"
        scripted_to_scm_log "`$scripted_db_directory.FullName        =[$($scripted_db_directory.FullName)]"
        scripted_to_scm_log "`$scm_db_path                           =[$scm_db_path]"

        $null = (remove_previous_scm_db_directory $scm_db_path)

        $null = (copy_to_scm $scm_db_path $scripted_db_directory $captured_on $server_n_instance $database_name)

        $null = (commit_to_scm $scm_db_path $captured_on $server_n_instance $database_name)

        $null = (remove_previous_scm_db_directory $scm_db_path)

        $null = (zip_scripted $scripted_db_directory)

        $SCRIPT:dbs_put_into_scm += 1
        if ( ( $SCRIPT:dbs_put_into_scm % 10 ) -eq 0 )
        {
            git_maintenance
        }
        scripted_to_scm_log "scripted_to_scm- bottom of loop.  scripted_db_directory=[$scripted_db_directory]."
    }

    scripted_to_scm_log "scripted_to_scm- DONE"    
}

function synch_loop ()
{
    Set-StrictMode -Version:Latest
    $GLOBAL:ErrorActionPreference               = "Stop"

    git_maintenance

    $sb = {scripted_to_scm}
    $SCRIPT:dbs_put_into_scm = 0
    loop_your_code -hours_to_run:$SCRIPT:stop_the_script_after_X_hours -seconds_to_pause:$SCRIPT:synch_every_X_seconds -code_block_to_invoke:$sb
}



$here =  ( Split-Path $MyInvocation.MyCommand.Definition )
$error.clear();
Set-StrictMode -Version:Latest
$GLOBAL:ErrorActionPreference               = "Stop"

. "$($MyInvocation.MyCommand.Definition).vars.ps1"
. "$here\commit_to_scm.ps1"
. "$here\copy_to_scm.ps1"
. "$here\git_maintenance.ps1"
. "$here\remove_previous_scm_db_directory.ps1"
. "$here\scripted_db_directories_to_copy.ps1"
. "$here\scripted_to_scm_log.ps1"
. "$here\zip_scripted.ps1"
. "$SCRIPT:code_common_directory\loop_d_loop.ps1"

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