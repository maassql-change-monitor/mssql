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
            write-host "No changes detected."    
        } 
    return $null
}


function create_reports_about_the_checkin ( $scrptd , $change_detected )
{
    $html = ( schema_checkin_as_html $scrptd  $change_detected )
    $checked_as_date = ( scripted_checked_date $scrptd )

    $null = ( shared_write_to_common_file ( html_file_report_every_check_by_date_recorded ) $html )
    $null = ( shared_write_to_common_file ( html_file_report_every_check_by_date_checked ($checked_as_date) ) $html )
    $null = ( shared_write_to_common_file ( html_file_report_every_check_by_instance $scrptd) $html )
    $null = ( shared_write_to_common_file ( html_file_report_every_check_dbname $scrptd) $html )

    if ( $change_detected -eq $true )
    {

        $null = ( shared_write_to_common_file ( html_file_report_changes_detected_by_date_recorded ) $html )
        $null = ( shared_write_to_common_file  ( html_file_report_changes_detected_by_date_checked ($checked_as_date) ) $html )
        $null = ( shared_write_to_common_file ( html_file_report_changes_detected_by_instance $scrptd) $html )
        $null = ( shared_write_to_common_file ( html_file_report_changes_detected_by_dbname $scrptd) $html )
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
    $null = ( shared_write_to_common_file ( processing_log_file ) $csv_line )
    return $null
}

function shared_write_to_common_file ( $file_name, $to_write )
{
    $try_max = 5
    do while ( (write_safe $file_name $to_write) -eq $false ){
        $try_max -= 1;
        if ($try_max -le 0)
        {
            break
        }
        start-sleep -Seconds:1
    }
}

function write_safe ( $file_name, $to_write )
{
    [boolean]$ret_written = $false

    try 
        {
            $to_write >> ( $file_name )  
            $ret_written = $true 
        }
    catch 
        {
            $to_log = "Exception whilst attempting to write to $file_name.  "
            $ex = $null
            if ($_.Exception -ne $null)
            {
                $ex = $_.Exception
            }
            if ( $ex -ne $null)
            {
                $to_log += $ex.Message
            }
            log_this $to_log
        }

    return $ret_written
}


