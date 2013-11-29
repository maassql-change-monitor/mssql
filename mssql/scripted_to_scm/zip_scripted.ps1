Function zip_scripted ( $scripted_db_directory )
{
    scripted_to_scm_log "zip_scripted - BEGIN | $($scripted_db_directory.FullName)" 
    
    $seven_z = "$($SCRIPT:seven_zip_bin_path)\7z.exe"
    $zip_args = @('a', "$($scripted_db_directory.FullName).7z", "-r" , ($scripted_db_directory.FullName) )

    scripted_to_scm_log "zip_scripted - zipping directory | $($scripted_db_directory.FullName)" 
    scripted_to_scm_log "$seven_z  $zip_args"



    $zip_results = (& "$seven_z" $zip_args )




    scripted_to_scm_log "zip_scripted - zipped=[$($zip_results)] | $($scripted_db_directory.FullName)" 
    if ( ( "$zip_results".Contains("Everything is Ok") ) -eq $true )
    {
        scripted_to_scm_log "zip_scripted - zip results say 'Everything is Ok', so removing directory. | $($scripted_db_directory.FullName)" 
        Remove-Item $($scripted_db_directory.FullName) -Recurse
    }
    else 
    {
      if ( $zip_results -eq $null )
      {
       scripted_to_scm_log "------------------------------  DAMN 7 zip results NULL bug -----------------------------------" 
      }
      scripted_to_scm_log "zip_scripted - zip results did NOT say 'Everything is Ok', so we left the directory alone..... | $($scripted_db_directory.FullName)"   
    }
    scripted_to_scm_log "zip_scripted - END | $($scripted_db_directory.FullName)" 
    return $null
}


    
