$error.clear();
Set-StrictMode -Version:Latest
$GLOBAL:ErrorActionPreference               = "Stop"

# region REFERENCES --------------------------------------------------------------------------------------------------------------------------------------
    $my_fullname_scripted_to_scm_psm1        = ($MyInvocation.MyCommand.Definition)
    $my_dir_scripted_to_scm_psm1             = ( Split-Path $my_fullname_scripted_to_scm_psm1 )

    . "$($my_dir_scripted_to_scm_psm1 )\config\scripted_to_scm.psm1.vars.ps1"
    . "$($my_dir_scripted_to_scm_psm1 )\reports\reports.ps1"
    # ---> NO!  this is done in the loop, main_looped_function
    #       import-module "$($my_dir_scripted_to_scm_psm1 )\looped\looped.psm1"     
    . "$($my_dir_scripted_to_scm_psm1 )\main_looped_function.ps1"
    . "$($my_dir_scripted_to_scm_psm1 )\process_changes.ps1"
    . "$($my_dir_scripted_to_scm_psm1 )\synch_loop.ps1"
    $SCRIPT:code_common_directory=( Resolve-Path "$my_dir_scripted_to_scm_psm1\..\..\common" )
    . "$SCRIPT:code_common_directory\common.ps1"
# end region REFERENCES --------------------------------------------------------------------------------------------------------------------------------------



# region SET RANGE OF INSTANCES TO WORK OVER --------------------------------------------------------------------------------------------------------------------------------------
    $GLOBAL:earliest_instance = 'A';
    $GLOBAL:latest_instance = 'ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ';
        <# WHY global?  Because this is a scripting language, that's why.  And I am lame.  This got added a whole lot later...... #>

    if ($args -ne $null)
    {
        $cnt = 1
        foreach ($a in $args)
        {

            switch ($cnt)
            {
                1 {$GLOBAL:earliest_instance = $a.ToUpper()}
                2 {$GLOBAL:latest_instance = $a.ToUpper()}
                default {throw "we expect 0, 1 or 2 args, begin 0=all scripted dbs, 1 = name of first instance to script, 2 = keep scripting till this db instance, but exclude."}
            }
            $cnt += 1
        }
    }
# end region SET RANGE OF INSTANCES TO WORK OVER --------------------------------------------------------------------------------------------------------------------------------------



function go_tell_it_on_the_mountain
{
    $who_am_i = "schema check gte $($GLOBAL:earliest_instance) & lt $($GLOBAL:latest_instance) - $pid"
    $Host.UI.RawUI.WindowTitle = $who_am_i
    write-host $who_am_i
    log_me_as $who_am_i
    log_this $who_am_i 
    return $null
}

Function main ()
{
    log_this "scripted_to_scm - main body - BEGIN"
    synch_loop
    log_this "AFTER synch_loop, count of `$Errors=[$($error.Count)]."
    log_this "scripted_to_scm - main body - out of synch_loop"
}

go_tell_it_on_the_mountain
main