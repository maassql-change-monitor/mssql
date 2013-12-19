Function commit_to_local_repository ($path_to_commit, $msg)
{
    write-host "commit_to_local_repository- BEGIN | $path_to_commit"

    cd $path_to_commit

    if ((Test-Path -LiteralPath:"$path_to_commit\.git\index.lock") -eq $true )  
    {
        throw ".git\index.lock exists.  NO BUENO!  path=[$path_to_commit\.git\index.lock]."
    }

    write-host "commit_to_local_repository ADD BEGIN ------- of=[$path_to_commit]" <# stage updates/deletes for ALL files, including new ones # Also a leading directory name (e.g. dir to add dir/file1 and dir/file2) can be given to add all files in the directory, recursively. #>
    #$git_args = @('add', "--all" , "$path_to_commit" )
    $null = ( git_exe_2 -path_to_repository:$path_to_commit -arg_string:"add --all  '$path_to_commit/'"  )
    write-host "commit_to_local_repository ADD DONE -------- of=[$path_to_commit]"

    if ((Test-Path -LiteralPath:"$path_to_commit\.git\index.lock") -eq $true )  
    {
        throw "AFTER running the ADD, .git\index.lock exists.  NO BUENO!  path=[$path_to_commit\.git\index.lock]."
    }


    write-host "commit_to_local_repository - Commiting - BEGIN | $path_to_commit"<# stage updates/deletes for files git already knows about AND COMMIT #>
    #$git_args = @('commit', "--message='$($msg)'") # , '--quiet' )
    $null = ( git_exe_2 -path_to_repository:$path_to_commit -arg_string:"commit" )  # --message='$($msg)' 
    <# TODO : look at $commit_results for [master ff61ceb] or for ? #>
    write-host "commit_to_local_repository - Commiting - DONE | $path_to_commit"    

    if ((Test-Path -LiteralPath:"$path_to_commit\.git\index.lock") -eq $true )  
    {
        throw "AFTER running the COMMIT, .git\index.lock exists.  NO BUENO!  path=[$path_to_commit\.git\index.lock]."
    }


    return $null
}


<# >> (log_file_name) 2>&1 #>