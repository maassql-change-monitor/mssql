Function commit_to_scm ($scm_db_path, $captured_on, $server_n_instance, $database_name)
{
    $log_base ="$captured_on | $server_n_instance | $database_name | $scm_db_path" 
    scripted_to_scm_log "commit_to_scm- BEGIN | $log_base"

    cd $scm_db_path

    $git_path = "$SCRIPT:git_bin_path\git.exe"


    scripted_to_scm_log "commit_to_scm - Adding files | $log_base" <# stage updates/deletes for ALL files, including new ones # Also a leading directory name (e.g. dir to add dir/file1 and dir/file2) can be given to add all files in the directory, recursively. #>
    $git_args = @('add', "--all" , "$scm_db_path")
    $add_results = (& $git_path $git_args )
    scripted_to_scm_log "commit_to_scm of=[$scm_db_path] - added=[$add_results] | $log_base"


    scripted_to_scm_log "commit_to_scm - Committing files | $log_base"<# stage updates/deletes for files git already knows about AND COMMIT #>
    $msg = "InstanceName=[$server_n_instance].  Db=[$database_name].  scripted_to_scm automation. Captured on=[$captured_on]."
    $msg_arg = "--message='$($msg)'"
    $git_args = @('commit', $msg_arg)
    $commit_results = (& $git_path $git_args )
    scripted_to_scm_log "commit_to_scm - commit=[$commit_results] | $log_base"
    <# TODO : look at $commit_results for [master ff61ceb] or for ? #>

    scripted_to_scm_log "commit_to_scm- DONE | $log_base"    
    return $null
}