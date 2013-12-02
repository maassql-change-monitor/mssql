
Function git_exe 
{

    [cmdletbinding()]
    Param (
        [Parameter(Mandatory=$true)]     [string]      $path_to_repository
        ,[Parameter(Mandatory=$true)]    [object[]]    $da_args
        ,[Parameter(Mandatory=$false)]   [switch]      $quiet
    )

    write-host "git_exe BEGIN.  `$path_to_repository=[$path_to_repository]."

    foreach ($arg in $da_args)
    {
        write-host "arg=$($arg)"
    }

    try 
    {
        cd $path_to_repository
        $results = (& $SCRIPT:git_path $da_args) 
    }
    catch [Exception]
    {
        $throw = $true
        $exception_Message = $_.Message
        if ($exception_Message -like "*warning: LF will be replaced by CRLF.*" )  { $throw = $false }
        if ( $throw -eq $true ) { throw $exception_Message}
    }
    write-host "git_exe END.  Results=[$results]."
    return $null
}

<#
Function git_exe_using_diag_proc
{
    $si = New-Object System.Diagnostics.ProcessStartInfo
    $si.Arguments = $da_args
    $si.UseShellExecute = $false
    $si.RedirectStandardOutput = $false
    $si.RedirectStandardError = $true
    $si.WorkingDirectory = $path_to_repository
    $si.FileName = $SCRIPT:git_path


    $process = ( [Diagnostics.Process]::Start($si) )
    try 
    {


        #$process.BeginOutputReadLine();
        $err = ($process.StandardError.ReadToEnd())
        $process.WaitForExit();

        while (!($process.HasExited))
        {
            # do what you want with strerr and stdout
            Start-Sleep -s 1  #sleep for 1s
        }

        $exit_code = ($process.ExitCode)
        
        

        if ($quiet -ne $true)
        {
          write-host "----------exit code-------------------------------------"
          write-host "$exit_code"
          write-host "----------std-out-------------------------------------"
          #write-host "$out"
          write-host "----------std-err-------------------------------------"
          write-host "$err"
        }

        if ($exit_code -ne 0)
        {
            throw "call to git exe failed.  exit code=[$exit_code].  args=[$da_args]."
        } 
    }  
    finally
    {
      $process.Dispose()  
    }  

    return $null
}
#>
