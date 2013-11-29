Function remove_previous_scm_db_directory ( $dir_to_remove )
{
    scripted_to_scm_log "remove_previous_scm_db_directory - remove previous=[$dir_to_remove] - BEGIN "
    $dir_to_remove_info = ( New-Object System.IO.DirectoryInfo $dir_to_remove )
    if ( ( $dir_to_remove_info.Exists ) -eq $true )
    {
        scripted_to_scm_log "remove_previous_scm_db_directory - remove previous=[$($dir_to_remove_info.FullName)] - about to remove... "
        #$dir_to_remove_info.Delete($true)  <# Remove-Item gives better error messages #>
        try 
        {
            Remove-Item -Recurse -Force -LiteralPath:($dir_to_remove_info.FullName)   
        }
        catch [Exception]
        {
           if ($_.Exception.Message -like "*Cannot remove the item at *because it is in use.*" ) 
           {
                scripted_to_scm_log "remove_previous_scm_db_directory - remove previous=[$($dir_to_remove_info.FullName)] - tried removing and it errd.  Err=[$($_.Exception.Message)]... "
           }
           else 
           {
              throw $_.Exception.Message
           } 
        } 
    }
    else 
    {
        scripted_to_scm_log "remove_previous_scm_db_directory - remove previous=[$dir_to_remove] - was not there to remove"
    }
    scripted_to_scm_log "remove_previous_scm_db_directory - remove previous=[$dir_to_remove] - DONE"
}