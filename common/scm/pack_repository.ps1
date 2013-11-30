Function pack_repository ($path_to_repository)
{
    write-host "git_maintenance BEGIN"

    cd $path_to_repository

    $git_args = @('gc', '--aggressive', ">> $(log_file_name)")
    $maint_results = (& $SCRIPT:git_path $git_args )
    write-host "git_maintenance - maint_results=[$maint_results]"

    write-host "git_maintenance END"  
}