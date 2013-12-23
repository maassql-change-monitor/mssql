$error.clear();
Set-StrictMode -Version:Latest
$GLOBAL:ErrorActionPreference               = "Stop"

$my_fullname        = ($MyInvocation.MyCommand.Definition)
$my_dir             = ( Split-Path $my_fullname )

. "$($my_dir )\config\scripted_to_scm.psm1.vars.ps1"
. "$($my_dir )\main_looped_function.ps1"
. "$($my_dir )\synch_loop.ps1"
# import-module "$($my_dir )\looped\looped.psm1"  ---> NO!  this is done in the loop, main_looped_function
. "$SCRIPT:code_common_directory\common.ps1"

# MAIN code......

scripted_to_scm_log "scripted_to_scm - main body - BEGIN"
synch_loop
scripted_to_scm_log "AFTER synch_loop, count of `$Errors=[$($error.Count)]."
scripted_to_scm_log "scripted_to_scm - main body - out of synch_loop"