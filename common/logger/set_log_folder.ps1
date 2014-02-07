Function GLOBAL:set_log_folder ( $log_directory_path )
{
    if ($log_directory_path -eq $null)
    {
        throw '$log_directory_path may not be null.'
    }
    if (( test-path $log_directory_path ) -eq $false )
    {
        throw "`$log_directory_path must be a valid windows path.  value passed in =[$log_directory_path]."
    }
    $SCRIPT:Log_directory = $log_directory_path
    return $SCRIPT:Log_directory
}