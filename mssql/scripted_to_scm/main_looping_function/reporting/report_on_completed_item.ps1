function report_on_completed_item ( $changes, $scrptd )
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
