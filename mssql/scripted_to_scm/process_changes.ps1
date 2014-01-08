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


function log_processing ( $scrptd , $change_detected )
{
    $instance                               = $scrptd.'instance'
    $dbname                                 = $scrptd.'dbname'
    $dttm_scripted                          = $scrptd.'dttm_human'
    $dttm_scripted_d                        = $scrptd.'dttm_date'
    $scripted_db_folder_name                = $scrptd.'folder'
    $scm_name                               = $scrptd.'scm_name'
    $scripted_db_directory_full_path        = $scrptd.'path'
    $scm_db_directory_full_path             = $scrptd.'scm_db_path'  



    

    $null = ( log_processing_to_file $change_detected  $instance  $dbname  $dttm_scripted  $scripted_db_folder_name  $scm_name  $scripted_db_directory_full_path  $scm_db_directory_full_path)
    $null = ( log_processing_to_db   $change_detected  $instance  $dbname  $dttm_scripted_d  $scripted_db_folder_name  $scm_name  $scripted_db_directory_full_path  $scm_db_directory_full_path)

    return $null
}

function log_processing_to_file ($change_detected , $instance , $dbname , $dttm_scripted , $scripted_db_folder_name , $scm_name , $scripted_db_directory_full_path , $scm_db_directory_full_path)
{
    $csv_line = "$pid , $(Get-Date) , $change_detected , $instance , $dbname , $dttm_scripted , $scripted_db_folder_name , $scm_name , $scripted_db_directory_full_path , $scm_db_directory_full_path" 
    $null = ( shared_write_to_common_file ( processing_log_file ) $csv_line )
    return $null
}


function log_processing_to_db ($change_detected , $instance , $dbname , $dttm_scripted , $scripted_db_folder_name , $scm_name , $scripted_db_directory_full_path , $scm_db_directory_full_path)
{

    $change_detected_frmt = 0
    if ($change_detected -eq $true ) { $change_detected_frmt = 1}

    $insert_query = @"
    EXECUTE dbo.scm_schema_checkin_history_insert
            `@change_detected                        = '$($change_detected_frmt)'              
            , `@instance                             = '$($instance)'                  
            , `@dbname                               = '$($dbname)'                     
            , `@dttm_scripted                        = '$($dttm_scripted.ToString("yyyy-MM-dd HH:mm:ss.FFFFFFF"))'               
            , `@scripted_db_folder_name              = '$($scripted_db_folder_name)'        
            , `@scm_name                             = '$($scm_name)'             
            , `@scripted_db_directory_full_path      = '$($scripted_db_directory_full_path)'     
            , `@scm_db_directory_full_path           = '$($scm_db_directory_full_path)'   
        ;
"@



    $null = (ExecNonQuery -ServerInstance:($SCRIPT:MSSQL_SCM_ServerInstance) -Database:($SCRIPT:MSSQL_SCM_Database) -Query:$insert_query)

    return $null
}
