function clear_repository($dir_to_remove)
{
    write-host "clear_repository | BEGIN | $dir_to_remove"

    $dir_to_remove_info = ( New-Object System.IO.DirectoryInfo $dir_to_remove )

    if ( $dir_to_remove_info.Exists -eq $true )
    {
        $git_repo_exists_before = ( git_repo_exists $dir_to_remove )


        $names_to_leave = @('.git', '.gitignore')
        $null = ( nuke_directory -dir_to_nuke:$dir_to_remove -names_to_leave:$names_to_leave -leave_directory )
        if ((Test-Path -LiteralPath:"$dir_to_remove\.git\index.lock") -eq $true )    
            { 
                Remove-Item -Force "$dir_to_remove\.git\index.lock" 
            } 


        $git_repo_exists_after = ( git_repo_exists $dir_to_remove )
        if ( $git_repo_exists_before -eq $true -and $git_repo_exists_after -eq $false )
        {
            throw "After we cleared the repository, the .git folder no longer existed.  This is a bug in the code that is 100% unrecoverable.  It must be fixed before running this software again. repository=[$dir_to_remove]."
        }
    }
    write-host "clear_repository | END | $dir_to_remove"
    return $null
}


