$error.clear();
Set-StrictMode -Version:Latest
$GLOBAL:ErrorActionPreference            = "Stop"

$my_fullname                             = ($MyInvocation.MyCommand.Definition)
$my_dir_scripted_to_scm_psm1             = ( Split-Path $my_fullname )

$SCRIPT:config_ps1 = "$($my_dir_scripted_to_scm_psm1 )\config\config.ps1"


. "$SCRIPT:code_common_directory\common.ps1"
import-module -force $SCRIPT:config_ps1
# import-module "$($my_dir )\looped\looped.psm1"  ---> NO!  this is done in the loop, main_looped_function
. "$($my_dir_scripted_to_scm_psm1 )\main_looping_function\main_looping_function.ps1"


function main 
{
    log_this "main - BEGIN"
    $code_block_to_invoke = {
        import-module -force $SCRIPT:config_ps1
        main_looped_function
        log_this "time to take a break.........[$($SCRIPT:synch_every_X_seconds)] seconds........"   
    }
    loop_your_code -hours_to_run:$SCRIPT:stop_the_script_after_X_hours -seconds_to_pause:$SCRIPT:synch_every_X_seconds -code_block_to_invoke:$code_block_to_invoke
    log_this "main - END - `$Errors.Count=[$($error.Count)]."
}


main