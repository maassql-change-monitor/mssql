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
    
    $null = ( create_reports_about_the_checkin $scrptd  $_change )

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


function create_reports_about_the_checkin ( $scrptd , $change_detected )
{
    $html = ( schema_checkin_as_html $scrptd  $change_detected )
    $checked_as_date = ( scripted_checked_date $scrptd )

    $html >> ( html_file_report_every_check_by_date_recorded )
    $html >> ( html_file_report_every_check_by_date_checked ($checked_as_date) )
    $html >> ( html_file_report_every_check_by_instance $scrptd)
    $html >> ( html_file_report_every_check_dbname $scrptd)
    if ( $change_detected -eq $true )
    {
      $html >> ( html_file_report_changes_detected_by_date_recorded )
      $html >> ( html_file_report_changes_detected_by_date_checked ($checked_as_date) )
      $html >> ( html_file_report_changes_detected_by_instance $scrptd)
      $html >> ( html_file_report_changes_detected_by_dbname $scrptd)
    }
    return $null
}