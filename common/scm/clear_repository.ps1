function clear_repository($dir_to_remove)
{
    write-host "clear_repository | BEGIN | $dir_to_remove"
    $names_to_leave = @('.git', '.gitignore')
    $null = ( nuke_directory -dir_to_nuke:$dir_to_remove -names_to_leave:$names_to_leave -leave_directory )

    if ((Test-Path -LiteralPath:"$dir_to_remove\.git\index.lock") -eq $true )    
        { 
            Remove-Item -Force "$dir_to_remove\.git\index.lock" 
        }
    write-host "clear_repository | END | $dir_to_remove"
    return $null
}
