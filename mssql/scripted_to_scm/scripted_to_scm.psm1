$error.clear();
Set-StrictMode -Version:Latest
$GLOBAL:ErrorActionPreference               = "Stop"

$my_fullname_scripted_to_scm_psm1        = ($MyInvocation.MyCommand.Definition)
$my_dir_scripted_to_scm_psm1             = ( Split-Path $my_fullname_scripted_to_scm_psm1 )

. "$($my_dir_scripted_to_scm_psm1 )\config\scripted_to_scm.psm1.vars.ps1"
. "$($my_dir_scripted_to_scm_psm1 )\html_file_names.ps1"
. "$($my_dir_scripted_to_scm_psm1 )\main_looped_function.ps1"
. "$($my_dir_scripted_to_scm_psm1 )\process_changes.ps1"
. "$($my_dir_scripted_to_scm_psm1 )\schema_checkin_as_html.ps1"
. "$($my_dir_scripted_to_scm_psm1 )\synch_loop.ps1"
# import-module "$($my_dir_scripted_to_scm_psm1 )\looped\looped.psm1"  ---> NO!  this is done in the loop, main_looped_function
$SCRIPT:code_common_directory=( Resolve-Path "$my_dir_scripted_to_scm_psm1\..\..\common" )
. "$SCRIPT:code_common_directory\common.ps1"


<#
import-module -force "C:\DBATools\maassql-change-monitor-2\mssql\scripted_to_scm\scripted_to_scm.psm1" -ArgumentList A,B
import-module -force "C:\DBATools\maassql-change-monitor-2\mssql\scripted_to_scm\scripted_to_scm.psm1" -ArgumentList B,H
import-module -force "C:\DBATools\maassql-change-monitor-2\mssql\scripted_to_scm\scripted_to_scm.psm1" -ArgumentList H,N
import-module -force "C:\DBATools\maassql-change-monitor-2\mssql\scripted_to_scm\scripted_to_scm.psm1" -ArgumentList N,P
import-module -force "C:\DBATools\maassql-change-monitor-2\mssql\scripted_to_scm\scripted_to_scm.psm1" -ArgumentList P
#>


$GLOBAL:earliest_instance = 'A';
$GLOBAL:latest_instance = 'ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ';

if ($args -ne $null)
{
    $cnt = 1
    foreach ($a in $args)
    {

        switch ($cnt)
        {
            1 {$GLOBAL:earliest_instance = $a}
            2 {$GLOBAL:latest_instance = $a}
            default {throw "we expect 0, 1 or 2 args, begin 0=all scripted dbs, 1 = name of first instance to script, 2 = keep scripting till this db instance, but exclude."}
        }
        $cnt += 1
    }
}

$who_am_i = "$pid checking in instances from [$($GLOBAL:earliest_instance)] to just before [$($GLOBAL:latest_instance)]."
write-host $who_am_i
scripted_to_scm_log $who_am_i




Function main ()
{
    scripted_to_scm_log "scripted_to_scm - main body - BEGIN"
    synch_loop
    scripted_to_scm_log "AFTER synch_loop, count of `$Errors=[$($error.Count)]."
    scripted_to_scm_log "scripted_to_scm - main body - out of synch_loop"
}

main