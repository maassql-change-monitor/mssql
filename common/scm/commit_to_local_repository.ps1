Function commit_to_local_repository ($path_to_commit, $msg)
{
    write-host "commit_to_local_repository- BEGIN | $path_to_commit"

    cd $path_to_commit

    write-host "commit_to_local_repository - Adding files" <# stage updates/deletes for ALL files, including new ones # Also a leading directory name (e.g. dir to add dir/file1 and dir/file2) can be given to add all files in the directory, recursively. #>
    $git_args = @('add', "--all" , "$path_to_commit")
    try 
    {
        $add_results = (& $git_path $git_args >> (log_file_name) 2>&1 )
    }
    catch [Exception]
    {
        $throw = $true
        $exception_Message = $_.Message
        if ($exception_Message -like "*warning: LF will be replaced by CRLF.*" )  { $throw = $false }
        if ( $throw -eq $true ) { throw $exception_Message}
    }    
    write-host "commit_to_local_repository of=[$path_to_commit] - added=[$add_results]"


    write-host "commit_to_local_repository - Committing files"<# stage updates/deletes for files git already knows about AND COMMIT #>
    $msg_arg = "--message='$($msg)'"
    $git_args = @('commit', $msg_arg)
    try 
    {
        $commit_results = (& $git_path $git_args >> (log_file_name) 2>&1 )    
    }
    catch [Exception]
    {
        $throw = $true
        $exception_Message = $_.Message
        if ($exception_Message -like "*warning: LF will be replaced by CRLF.*" )  { $throw = $false }
        if ( $throw -eq $true ) { throw $exception_Message}
    }
    write-host "commit_to_local_repository - commit=[$commit_results]"
    <# TODO : look at $commit_results for [master ff61ceb] or for ? #>

    write-host "commit_to_local_repository- DONE | $path_to_commit"    
    return $null
}