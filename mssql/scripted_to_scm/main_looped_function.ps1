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
    $null=(process_changes $changes $scrptd)
    return $null  
}

function process_changes ( $changes, $scrptd )
{
    write-debug "----------------------------"
    write-debug "$($changes | format-table | out-string)"
    write-debug "----------------------------"
    write-debug "$($changes | get-member | out-string)"
    write-debug "----------------------------"
    write-debug "contains has_changes key=[$($changes.ContainsKey("has_changes"))]"
    write-debug "----------------------------"
    $_change = $false
    $_output = ""

    foreach ( $item in $changes.GetEnumerator() )
    {
        write-debug "*************************************************"
        write-debug "$($item | format-table | out-string)"
        write-debug "*************************************************"
        write-debug "$($item | get-member | out-string)"
        write-debug "*************************************************"
        if ($item.Name -eq 'has_changes')
        {
            if ($item.Value -eq $true)
            {
               $_change = $true
            }
        }
        if ($item.Name -eq 'filtered_output')
        {
            $_output = $item.Value
        }        
    }
    write-debug "----------------------------"
    $null = ( log_the_check_for_changes $scrptd  $_change )
    if ($_change -eq $true)
    {
        $null = ( email_a_change $scrptd $_output )
    }
    else 
    {
        write-host "We didn't detect any changes, so we are not going to alert anyone...has_changes=[$($_change)]"    
    } 
    return $null
}


function commit_message ($scrptd)
{
   return "InstanceName=[$($scrptd.'instance')].  Db=[$($scrptd.'dbname')].  main_looped_function automation. Captured on=[$($scrptd.'dttm')]."
}


function log_the_check_for_changes( $scrptd , $change_detected)
{
    $x_to_scm = (xml_tag "to_scm" ((Get-Date).ToUniversalTime().ToString("yyyyMMddzz HH:MM:SS")))
    $x_instance = (xml_tag "mssql_instance" ($scrptd.'instance'))
    $x_db_name = (xml_tag "db" ($scrptd.'dbname'))
    $x_checked_when = (xml_tag "checked_when" ($scrptd.'dttm'))
    $x_checked_deteced = (xml_tag "change_detected" $change_detected)

    $to_log = "$x_checked_when | $x_to_scm | $x_instance | $x_db_name | $x_checked_deteced | " 
    $to_log  >> ($SCRIPT:change_check_log)
}

function xml_tag ($name, $value)
{
    return "<$name>$value</$name>"
}


Function email_a_change 
    (
        $scrptd
        , $git_commit_std
    ) 
{ 

    write-host "emailing a change......................."

    $who_changed="$($scrptd.'instance').$($scrptd.'dbname')"

    $message = @" 

    Changes detected to ==> $who_changed

    Schema and settings were checked at : $($scrptd.'dttm').
    Changes could have occurred anytime between the last check and $($scrptd.'dttm').

    For details, see, http://nghsdemosql:81/gitweb/gitweb.cgi

    Git Add & Commit StdOut / StdErr :
    ==================================================================
    $git_commit_std
    ==================================================================
"@    
    $emailFrom = "msssql_schema_change_detection@nextgen.com" 
    $subject= "CM:$who_changed"
    $smtpserver="PHLVPEXCHCAS01.nextgen.com" 
    $smtp=new-object Net.Mail.SmtpClient($smtpServer)     
    $email_addrses = @("jmaass@nextgen.com", 'wbrown@nextgen.com', 'cmiller@nextgen.com')
    foreach ($emailTo in $email_addrses)
    {
        $smtp.Send($emailFrom, $emailTo, $subject, $message) 
    }
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