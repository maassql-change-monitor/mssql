function run_process ( $executable_path_n_name, $arguments, $working_directory)
{
    $process = Create-Process

    try 
    {
        $process.StartInfo.FileName = $executable_path_n_name
        $process.StartInfo.Arguments = $single_argument_string
        $process.StartInfo.WorkingDirectory = $working_directory
        
        scripted_to_scm_log "executable = [$executable_path_n_name]"
        scripted_to_scm_log "arg_string = [$single_argument_string]"
        scripted_to_scm_log "working directory = [$working_directory]"

        $ret = ( Launch-Process $process )
        return $ret
    }
    finally
    {
        Terminate-Process $process     
    }
}


<#
2/18/2013 18:35:59 | executable = [C:\Program Files (x86)\Git\bin\git.exe]
12/18/2013 18:35:59 | arg_string = [tag -a 'InstanceName=[LYNWDB1_default].  Db=[iDashboards].  main_looped_function automation. Captured on=[20131205T220357030].' -m 'A snapshot commit was requested at:[12/18/2013 18:35:59].  The commit message was:[InstanceName=[LYNWDB1_default].  Db=[iDashboards].  main_looped_function automation. Captured on=[20131205T220357030].].']
12/18/2013 18:35:59 | working directory = [F:\scm_databases\LYNWDB1_default.iDashboards]
ERROR - fatal: too many params


C:\Program Files (x86)\Git\bin\git.exe tag -a 'InstanceName=[LYNWDB1_default].  Db=[iDashboards].  main_looped_function automation. Captured on=[20131205T220357030].' -m 'A snapshot commit was requested at:[12/18/2013 18:35:59].  The commit message was:[InstanceName=[LYNWDB1_default].  Db=[iDashboards].  main_looped_function automation. Captured on=[20131205T220357030].].'


git.exe tag -a '20131205T220357030' -m 'A snapshot commit was requested at:[12/18/2013 18:35:59].  The commit message was:[InstanceName=[LYNWDB1_default].  Db=[iDashboards].  main_looped_function automation. Captured on=[20131205T220357030].].'


12/18/2013 18:44:57 | arg_string = [tag -a 20131205T220428247 -m 'A snapshot commit was requested at:[12/18/2013 18:44:57].  The commit message was:[InstanceName=[LYNWDB1_default].  Db=[NGDemo].  main_looped_function automation. Captured on=[20131205T220428247].].']

F:\scm_databases\LYNWDB1_default.NGDemo
git tag -a 20131205T2204282473 -m 'A snapshot commit was requested at:[12/18/2013 18:44:57].  The commit message was:[InstanceName=[LYNWDB1_default].  Db=[NGDemo].  main_looped_function automation. Captured on=[20131205T220428247].].'


#>



