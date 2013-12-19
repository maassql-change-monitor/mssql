function git_repo_lock_file($repo_path)
{
    return "$repo_path\.git\index.lock"
}


function git_repo_lock_file_exists($repo_path)
{
    return (Test-Path -LiteralPath:(git_repo_lock_file $repo_path)  )  
}


function git_repo_lock_remove($repo_path)
{
    if (git_repo_lock_file_exists $repo_path) 
    {
        $lock_file = ( git_repo_lock_file $repo_path )
        write-warning "Removing $lock_file"
        scripted_to_scm_log "Removing $lock_file"
        Remove-Item -Force $git_repo_lock_file <# Need force to remove read only or hidden file ( one of the 2...? ) #>
    }    
}


function assert_no_git_lock ($repo_path)
{
    if (git_repo_lock_file_exists $repo_path) 
    {
        throw "The git repository is locked by an index.lock file."
    }  
}