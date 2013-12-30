$error.clear();
Set-StrictMode -Version:Latest
$GLOBAL:ErrorActionPreference               = "Stop"

$my_fullname_scripted_to_scm_psm1        = ($MyInvocation.MyCommand.Definition)
$my_dir_scripted_to_scm_psm1             = ( Split-Path $my_fullname_scripted_to_scm_psm1 )

. "$($my_dir_scripted_to_scm_psm1 )\config\scripted_to_scm.psm1.vars.ps1"
. "$($my_dir_scripted_to_scm_psm1 )\main_looped_function.ps1"
. "$($my_dir_scripted_to_scm_psm1 )\synch_loop.ps1"
# import-module "$($my_dir_scripted_to_scm_psm1 )\looped\looped.psm1"  ---> NO!  this is done in the loop, main_looped_function
$SCRIPT:code_common_directory=( Resolve-Path "$my_dir_scripted_to_scm_psm1\..\..\common" )
. "$SCRIPT:code_common_directory\common.ps1"




Function main ()
{
    scripted_to_scm_log "scripted_to_scm - main body - BEGIN"
    synch_loop
    scripted_to_scm_log "AFTER synch_loop, count of `$Errors=[$($error.Count)]."
    scripted_to_scm_log "scripted_to_scm - main body - out of synch_loop"
}



main