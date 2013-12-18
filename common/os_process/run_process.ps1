function run_process ( $executable_name, $arguments, $working_directory)
{
    $process = Create-Process

    try 
    {
        $process.StartInfo.FileName = $executable_path_n_name
        $process.StartInfo.Arguments = $single_argument_string
        $process.StartInfo.WorkingDirectory = $working_directory
                
        $ret = ( Launch-Process $process )
        return $ret
    }
    finally
    {
        Terminate-Process $process     
    }
}