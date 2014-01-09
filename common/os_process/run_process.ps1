function run_process ( $executable_path_n_name, $arguments, $working_directory)
{
    $process = Create-Process

    try 
    {
        $process.StartInfo.FileName = $executable_path_n_name
        $process.StartInfo.Arguments = $single_argument_string
        $process.StartInfo.WorkingDirectory = $working_directory
        
        $null = ( log_this "executable          = [$executable_path_n_name]"  'os_process')
        $null = ( log_this "arg_string          = [$single_argument_string]"  'os_process')
        $null = ( log_this "working directory   = [$working_directory]"  'os_process')

        $it_finished = ( Launch-Process $process )

        [string]$std = ($GLOBAL:stream)
        return ($std)
    }
    finally
    {
        $null = ( Terminate-Process $process )     
    }
}