
<#
Function git_exe 
{

    [cmdletbinding()]
    Param (
        [Parameter(Mandatory=$true)]     [string]      $path_to_repository
        ,[Parameter(Mandatory=$true)]    [object[]]    $da_args
        ,[Parameter(Mandatory=$false)]   [switch]      $quiet
    )


    return ( git_exe_2 $path_to_repository $da_args )


    write-host "git_exe BEGIN.  `$path_to_repository=[$path_to_repository]."
    try 
    {
        cd $path_to_repository
        $git_exe = $SCRIPT:git_path
        $caught = ( & $git_exe $da_args ) 
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
#>

Function git_exe_2
{

    [cmdletbinding()]
    Param (
        [Parameter(Mandatory=$true)]     [string]      $path_to_repository
        ,[Parameter(Mandatory=$true)]    [string]      $arg_string
    )

    $null = (scripted_to_scm_log "git_exe_2 BEGIN.  `$arg_string=[$arg_string] `$path_to_repository=[$path_to_repository]")

    $null = (cd $path_to_repository)

    $executable_path_n_name = $SCRIPT:git_path
    $single_argument_string = $arg_string
    $working_directory = $path_to_repository

    $null = (assert_no_git_lock $path_to_repository)
    $ret_val = ( run_process $executable_path_n_name $single_argument_string $working_directory )
    $null = (assert_no_git_lock $path_to_repository)

    $null = (scripted_to_scm_log "git_exe_2 DONE.  `$ret_val=[$ret_val]  `$arg_string=[$arg_string] `$path_to_repository=[$path_to_repository]" )

    return $ret_val    
}