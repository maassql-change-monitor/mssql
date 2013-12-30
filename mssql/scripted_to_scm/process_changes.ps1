
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
    }
    else 
    {
        write-host "We didn't detect any changes, so we are not going to alert anyone...has_changes=[$($_change)]"    
    } 
    return $null
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