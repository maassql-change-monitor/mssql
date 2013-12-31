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
    $change_detected = $false
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
                   $change_detected = $true
                }
            }
            if ($item.Name -eq 'filtered_output')
            {
                $_output = $item.Value
            }        
        }
    $null = ( log_processing $scrptd  $change_detected )
    $null = ( create_reports_about_the_checkin $scrptd  $change_detected )
    
    if ($change_detected -eq $true)
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

function log_processing ( $scrptd , $change_detected )
{
    $instance                               = $scrptd.'instance'
    $dbname                                 = $scrptd.'dbname'
    $dttm_scripted                          = $scrptd.'dttm_human'
    $scripted_db_folder_name                = $scrptd.'folder'
    $scm_name                               = $scrptd.'scm_name'
    $scripted_db_directory_full_path        = $scrptd.'path'
    $scm_db_directory_full_path             = $scrptd.'scm_db_path'  

    $csv_line = "$pid , $(Get-Date) , $change_detected , $instance , $dbname , $dttm_scripted , $scripted_db_folder_name , $scm_name , $scripted_db_directory_full_path , $scm_db_directory_full_path" 
    $csv_line >> ( processing_log_file )
    return $null
}



