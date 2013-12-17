function synch_loop ()
{
    Set-StrictMode -Version:Latest
    $GLOBAL:ErrorActionPreference               = "Stop"
    $sb = {main_looped_function}
    $SCRIPT:dbs_put_into_scm = 0
    loop_your_code -hours_to_run:$SCRIPT:stop_the_script_after_X_hours -seconds_to_pause:$SCRIPT:synch_every_X_seconds -code_block_to_invoke:$sb
}