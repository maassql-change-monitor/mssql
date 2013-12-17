

Function git_exe 
{

    [cmdletbinding()]
    Param (
        [Parameter(Mandatory=$true)]     [string]      $path_to_repository
        ,[Parameter(Mandatory=$true)]    [object[]]    $da_args
        ,[Parameter(Mandatory=$false)]   [switch]      $quiet
    )

    write-host "git_exe BEGIN.  `$path_to_repository=[$path_to_repository]."
    try 
    {
        cd $path_to_repository
        $git_exe = $SCRIPT:git_path
        $caught = ( & $git_exe $da_args 2>&1 | out-file (log_file_name) )
    }
    catch [Exception]
    {
        $throw = $true
        $exception_Message = $_.Exception.Message
        write-host $exception_Message
        if ($exception_Message -like "*LF will be replaced by CRLF*" )  { $throw = $false }
        if ( $throw -eq $true ) 
        { 
            write-host "Exception Type: $($_.Exception.GetType().FullName)" -ForegroundColor Red
            write-host "Exception Message: $($_.Exception.Message)" -ForegroundColor Red            
            throw $exception_Message
        }
    }
    write-host "git_exe END."
    return $null
}