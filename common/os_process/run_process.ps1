function run_process ( $executable_path_n_name, $arguments, $working_directory)
{
    $process = Create-Process

    try 
    {
        $GLOBAL:stream = ""
        
        $process.StartInfo.FileName = $executable_path_n_name
        $process.StartInfo.Arguments = $single_argument_string
        $process.StartInfo.WorkingDirectory = $working_directory
        
        scripted_to_scm_log "executable          = [$executable_path_n_name]"
        scripted_to_scm_log "arg_string          = [$single_argument_string]"
        scripted_to_scm_log "working directory   = [$working_directory]"

        $null = ( Launch-Process $process )

        return ($GLOBAL:stream)
    }
    finally
    {
        Terminate-Process $process     
    }
}