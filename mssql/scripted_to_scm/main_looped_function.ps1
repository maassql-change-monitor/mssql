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

    email_summary

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
    $commit_msg = (commit_message $scrptd)
    $changes = ( snapshot_commit -snapshot_tag:"$($scrptd.'dttm')" -remove_snapshot_path -clear_repository_after_commit -local_repository_path:($scrptd.'scm_db_path') -local_snapshot_path:($scrptd.'path') -snapshot_commit_message:$commit_msg )
    $null=(process_changes $changes $scrptd)
    return $null  
}



$SCRIPT:changes_observed = @{};
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
    $null = ( scripted_to_scm_log "$($scrptd.scm_name) --- CHANGE_DETECTED=$_change ----------------" )
    
    $null = ( check_for_changes_html $scrptd  $_change )

    if ($_change -eq $true)
    {
        $SCRIPT:changes_observed["$($scrptd.'instance').$($scrptd.'dbname')"] = @{
                "scrptd" = $scrptd ;
                "output" = $_output     
        }
        #$null = ( email_a_change $scrptd $_output )
    }
    else 
    {
        write-host "We didn't detect any changes, so we are not going to alert anyone...has_changes=[$($_change)]"    
    } 
    return $null
}


function commit_message ($scrptd)
{
   return "Checked_on_$($scrptd.'dttm')"
}


function check_for_changes_html ( $scrptd , $change_detected )
{
    $who = "$($scrptd.'instance').$($scrptd.'dbname')"

    $checked_as_date = [System.Convert]::ToDateTime( ($scrptd.'dttm').insert(4, '.').insert(7, '.').insert(13, ':').Substring(0,16) )
    $checked_as_date_string = $checked_as_date.ToString("yyyy.MM.dd")
    $checked = $checked_as_date.ToString("yyyy.MM.dd HH:mm")
    $now = (Get-Date).ToUniversalTime().ToString("yyyy.MM.dd HH:mm")

    $url_diff = (url_last_change $scrptd)
    if ($change_detected -eq $true)
    {
        $changed = 'CHANGED'
    }
    else
    {
        $changed = 'same'
    }

    $st="style='border:1px solid black;'"
    $html = "<table $($st)><tr $($st)><td $($st)>$checked</td><td>$now</td><td $($st)>$changed</td><td><a href='$url_diff' target='_blank'>$who</a></td></tr></table>"
    
    $html >> $SCRIPT:change_html_every
    $html >> $SCRIPT:change_html_every_by_checked_date.Replace('{dttm}', $checked_as_date_string) 


    if ( $change_detected -eq $true )
    {
      $html >> $SCRIPT:change_html_changes 
      $html >> $SCRIPT:change_html_changes_by_checked_date.Replace('{dttm}', $checked_as_date_string) 
    }





}

function xml_tag ($name, $value)
{
    return "<$name>$value</$name>"
}


function url_base ($scrptd)
{
    return "http://nghsdemosql:81/gitweb/gitweb.cgi?p=$($scrptd.'instance').$($scrptd.'dbname')/.git"
}

function url_last_change ($scrptd)
{
    $url_base=( url_base $scrptd )
    return "$url_base;a=commitdiff;h=HEAD" 
}



function email_summary () 
{
    write-host "should we send an email summary?"
    $summary_email_body = ""
    foreach ($who in $SCRIPT:changes_observed.GetEnumerator())
    {
       $hash_output = $who.value
       $scrptd = $hash_output."scrptd"
       $_output = $hash_output."output"

       $summary_email_body += "$([Environment]::NewLine)$($who.key) = $(url_last_change $scrptd)"
    }
    if ($summary_email_body -ne '')
    {
        $summary_email_body = "
        
        Change Reports :         http://nghsdemosql:81/msssql_scm/

        Changes detected ==>  $([Environment]::NewLine)$summary_email_body"
        $null = (email_about_changes $summary_email_body  "Databases Changed" )
    }
}


function email_about_changes ( $message,  $who_changed)
{
    return $null
    <#
    GLee
    SHermans
    JBaweja
    DMehegan
    ixie
    rlaschiver
    kwebb
    mcarter
    #>   
    $emailFrom = "msssql_schema_change_detection@nextgen.com" 
    $subject= "CM:$who_changed"
    $smtpserver="PHLVPEXCHCAS01.nextgen.com" 
    $smtp=new-object Net.Mail.SmtpClient($smtpServer)     
    $email_addrses = @("jmaass@nextgen.com", 'Dhammitt@nextgen.com')
    foreach ($emailTo in $email_addrses)
    {
        $smtp.Send($emailFrom, $emailTo, $subject, $message) 
    }
    return $null
}

Function email_a_change 
    (
        $scrptd
        , $git_commit_std
    ) 
{ 

    write-host "emailing a change......................."

    $who_changed="$($scrptd.'instance').$($scrptd.'dbname')"

    $url_base=( url_base $scrptd )

    $message = @" 

    Changes detected to ==> $who_changed

    Schema and settings were checked at : $($scrptd.'dttm').
    Changes could have occurred anytime between the last check and $($scrptd.'dttm').

    For details, see, 

        Last Change Details     = $url_base;a=commitdiff;h=HEAD   
        Summary                 = $url_base;a=summary
        Check History           = $url_base;a=tags
        Files                   = $url_base;a=tree
        Last Change             = $url_base;a=commit;h=HEAD
        Changes                 = $url_base;a=shortlog
        Changes Detailed        = $url_base;a=log;h=HEAD

    All Databases :          http://nghsdemosql:81/gitweb/gitweb.cgi
    Change Reports :         http://nghsdemosql:81/msssql_scm/


    Git Add & Commit StdOut / StdErr :
    ==================================================================
    $git_commit_std
    ==================================================================
"@  


   $null = (email_about_changes $message  $who_changed )
   return $null
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