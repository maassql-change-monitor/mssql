Function commit_to_local_repository ($path_to_commit, $msg)
{
    write-host "commit_to_local_repository- BEGIN | $path_to_commit"

    cd $path_to_commit

    write-host "commit_to_local_repository - Adding files" <# stage updates/deletes for ALL files, including new ones # Also a leading directory name (e.g. dir to add dir/file1 and dir/file2) can be given to add all files in the directory, recursively. #>
    $git_args = @('add', "--all" , "$path_to_commit" )
    $null = ( git_exe -path_to_repository:$path_to_commit -da_args:$git_args  )
    write-host "commit_to_local_repository of=[$path_to_commit] - added"


    write-host "commit_to_local_repository - Committing files"<# stage updates/deletes for files git already knows about AND COMMIT #>
    $git_args = @('commit', "--message='$($msg)'") # , '--quiet' )
    $null = ( git_exe -path_to_repository:$path_to_commit -da_args:$git_args  )  
    <# TODO : look at $commit_results for [master ff61ceb] or for ? #>

    write-host "commit_to_local_repository- DONE | $path_to_commit"    
    return $null
}


<# >> (log_file_name) 2>&1 #>