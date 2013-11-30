Function pack_repository ($path_to_repository)
{
    write-host "pack_repository BEGIN `$path_to_repository=[$path_to_repository]"

    cd $path_to_repository

    $git_args = @('gc', '--aggressive', ">> $(log_file_name)")
    $maint_results = (& $SCRIPT:git_path $git_args )
    write-host "pack_repository - maint_results=[$maint_results]"

    write-host "pack_repository END"  
}