Function commit_to_local_repository ($path_to_commit, $msg)
{
    write-host "commit_to_local_repository- BEGIN | $path_to_commit"

    cd $path_to_commit

    if ((Test-Path -LiteralPath:"$path_to_commit\.git\index.lock") -eq $true )  
    {
        throw "  Before we even try to add or commit anything, .git\index.lock exists.  NO BUENO!  path=[$path_to_commit\.git\index.lock]."
    }




    $null = ( git_exe_2 -path_to_repository:$path_to_commit -arg_string:"add --all '$path_to_commit'"  )
    if ((Test-Path -LiteralPath:"$path_to_commit\.git\index.lock") -eq $true )  
    {
        throw "AFTER running the ADD, .git\index.lock exists.  NO BUENO!  path=[$path_to_commit\.git\index.lock]."
    }



    $null = ( git_exe_2 -path_to_repository:$path_to_commit -arg_string:"commit -a -m 'automation' " )  # --message='$($msg)' 
    <# TODO : look at $commit_results for [master ff61ceb] or for ? #>
    if ((Test-Path -LiteralPath:"$path_to_commit\.git\index.lock") -eq $true )  
    {
        throw "AFTER running the COMMIT, .git\index.lock exists.  NO BUENO!  path=[$path_to_commit\.git\index.lock]."
    }

    write-host "commit_to_local_repository- DONE | $path_to_commit"
    return $null
}