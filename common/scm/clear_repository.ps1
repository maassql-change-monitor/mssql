function clear_repository($dir_to_remove)
{
    $names_to_leave = @('.git', '.gitignore')
    $null = ( nuke_directory -dir_to_nuke:$dir_to_remove $names_to_leave -leave_directory )
    return $null
}
