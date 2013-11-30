Function pack_repository ($path_to_repository)
{
    write-host "pack_repository BEGIN `$path_to_repository=[$path_to_repository]"

    cd $path_to_repository

    $git_args = @('gc', '--aggressive' )#, '--quiet' )
    $null = ( git_exe -path_to_repository:$path_to_repository -da_args:$git_args -quiet:$false ) 
    write-host "pack_repository END"  
}