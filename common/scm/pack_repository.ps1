Function pack_repository ($path_to_repository)
{
    write-host "pack_repository BEGIN `$path_to_repository=[$path_to_repository]"
    if ( (git_repo_exists $path_to_repository) -eq $true )
    {
        cd $path_to_repository
        $git_args = @('gc', '--aggressive' )#, '--quiet' )
        $null = ( git_exe_2 -path_to_repository:$path_to_repository -arg_string:'gc --aggressive'  ) 
    }
    else 
    {
        write-warning "There is no git repository at the path=[$path_to_repository]."
    }
    write-host "pack_repository END"  
}