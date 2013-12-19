function main_looped_function ()
{
    Set-StrictMode -Version:Latest
    $GLOBAL:ErrorActionPreference               = "Stop"  


    scripted_to_scm_log ""
    scripted_to_scm_log ""
    scripted_to_scm_log ""
    scripted_to_scm_log "-----------------------------------------------------------------------------------"
    scripted_to_scm_log "main_looped_function- BEGIN"

    $looped = loopd_obj

    foreach ( $scripted_db_directory in ( $looped.scripted_db_directories_to_copy($SCRIPT:scripted_db_directory_base_path, $SCRIPT:scripted_db_directory_must_sit_idle_for_x_minutes, $SCRIPT:directories_to_grab_at_a_time )))
    {
        scripted_to_scm_log ""
        scripted_to_scm_log ""
        scripted_to_scm_log ""
        scripted_to_scm_log "==================================================================================================="        
        scripted_to_scm_log "main_looped_function- top of loop.  scripted_db_directory=[$scripted_db_directory]."
        write-host ""
        write-host ""
        write-host ""
        write-host ""
        write-host "working on directory = [$scripted_db_directory]"

        submit_scripted_db_dir $scripted_db_directory
    
        scripted_to_scm_log "main_looped_function- bottom of loop.  scripted_db_directory=[$scripted_db_directory]."

        exit_if_signaled
    }

    Remove-Variable ("looped") -ErrorAction SilentlyContinue

    exit_if_signaled

    write-host "about to call the end scripted_to_scm_log under main_looped_function"
    scripted_to_scm_log "main_looped_function- DONE"    
}


Function submit_scripted_db_dir ($scripted_db_directory)
{

    if ( $scripted_db_directory -eq $null )
        {
            return $null
        }

    cd $SCRIPT:scripted_db_directory_base_path
    $scrptd = ($looped.scripted_db_properties( $scripted_db_directory, $SCRIPT:scm_db_script_name, $SCRIPT:scm_db_script_directory_base))
    $commit_msg = commit_message $scrptd
    $changes = ( snapshot_commit -snapshot_tag:"$($scrptd.'dttm')" -remove_snapshot_path -clear_repository_after_commit -local_repository_path:($scrptd.'scm_db_path') -local_snapshot_path:($scrptd.'path') -snapshot_commit_message:$commit_msg )
    $null=(process_changes $changes)
    return $null  
}

function process_changes ( $changes, $commit_msg )
{
    write-host "----------------------------"
    write-host "$($changes | format-table | out-string)"
    write-host "----------------------------"
    write-host "$($changes | get-member | out-string)"
    write-host "----------------------------"
    write-host "contains has_changes key=[$($changes.ContainsKey("has_changes"))]"
    write-host "----------------------------"
    foreach ( $item in $changes.GetEnumerator() )
    {
        write-host "*************************************************"
        write-host "$($item | format-table | out-string)"
        write-host "*************************************************"
        write-host "$($item | get-member | out-string)"
        write-host "*************************************************"
    }
    write-host "----------------------------"
    if ($changes['has_changes'] -eq $true)
    {
        email_a_change $commit_msg $changes["filtered_output"]
    }
    else 
    {
        write-host "We didn't detect any changes, so we are not going to alert anyone...has_changes=[$($changes[1]."has_changes")]"    
    } 
    return $null
}


function commit_message ($scrptd)
{
   return "InstanceName=[$($scrptd.'instance')].  Db=[$($scrptd.'dbname')].  main_looped_function automation. Captured on=[$($scrptd.'dttm')]."
}




Function email_a_change 
    (
        $what_changed
        , $git_commit_std
    ) 
{ 

    write-host "emailing a change......................."

    $message = @" 
See http://nghsdemosql:81/gitweb/gitweb.cgi

    Click on the Project for : $what_changed

Git Add & Commit StdOut / StdErr :

$git_commit_std
"@        

    $emailTo = "jmaass@nextgen.com;wbrown@nextgen.com"
    $emailFrom = "msssql_schema_change_detection@nextgen.com" 
    $subject="CHANGES......$what_changed" 
    $smtpserver="PHLVPEXCHCAS01.nextgen.com" 
    $smtp=new-object Net.Mail.SmtpClient($smtpServer) 
    $smtp.Send($emailFrom, $emailTo, $subject, $message) 
} 


function exit_if_signaled
{
    if ( $SCRIPT:my_exit_loop_flag_file -eq $null -or $SCRIPT:my_exit_loop_flag_file -eq '' ) { throw "CRAP.  `$SCRIPT:my_exit_loop_flag_file is null. or empty string."}
    if ( ( Test-Path  $SCRIPT:my_exit_loop_flag_file ) -eq $true )
    {
        throw "The flag file for exiting was found.  Throwing error in order to exit process."
    }
}


function loopd_obj
{
    $my_dir             = ( Split-Path $my_fullname )

    $looped = New-Module { 
        $error.clear();
        Set-StrictMode -Version:Latest
        $GLOBAL:ErrorActionPreference               = "Stop"        

        $path_to_module =  "$($args[0])\looped\looped.psm1"     
        import-module  $path_to_module 
        Export-ModuleMember -Variable * -Function *                
        } -asCustomObject -ArgumentList:@($my_dir)


    return $looped
}