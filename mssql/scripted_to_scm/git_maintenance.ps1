Function git_maintenance ()
{
    scripted_to_scm_log "git_maintenance BEGIN"

    cd $SCRIPT:scripted_db_directory

    $git_path = "$SCRIPT:git_bin_path\git.exe"

    $git_args = @('gc', '--aggressive')
    $maint_results = (& $git_path $git_args )
    scripted_to_scm_log "git_maintenance - maint_results=[$maint_results]"

    scripted_to_scm_log "git_maintenance END"  
}