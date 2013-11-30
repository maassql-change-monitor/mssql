<# 
.EXAMPLE
  nuke_directory -dir_to_nuke:'F:\scm_databases\.git\' -names_to_leave:$null
#>
function nuke_directory ($dir_to_nuke, $names_to_leave)
{
    if ( $names_to_leave -eq $null ) { $names_to_leave = @() }

    $SCRIPT:files_in_use = $null
    $SCRIPT:files_in_use = New-Object System.Collections.ArrayList

    write-host "nuke_directory - BEGIN - [$dir_to_nuke]"
    $dir_to_remove_info = ( New-Object System.IO.DirectoryInfo $dir_to_nuke )

    if ( ( $dir_to_remove_info.Exists ) -eq $true )
    {
        write-host "     Yes, the directory does exist."
        
        $null = (set_directory_read_only_false $dir_to_nuke)

        $delete_one_at_time = $true

        if ( $names_to_leave.Count -eq 0 ) 
        { 
          <# try simply deleting the directory #>       
          $delete_one_at_time = $false
        }
  
        write-debug "     `$delete_one_at_time =[$delete_one_at_time]"

        if ( $delete_one_at_time -eq $false )
        {
          try 
          {
            write-host "     Trying to delete the entire directory."
            $dir_to_remove_info.Delete($true)   
          }
          catch 
          { 
            write-host "    Unable to delete entire directory.  Going to try delete one file at a time."
            $delete_one_at_time = $true
          }
        }

        write-debug "     `$delete_one_at_time =[$delete_one_at_time]"
        if ( $delete_one_at_time -eq $true )
        {
          $null = (nuke_directory_one_file_at_a_time -dir_to_nuke:$dir_to_nuke  -names_to_leave:$names_to_leave)
        }        
    }
    else 
    {
        write-host "     The Directory was not there to remove."
    }
    write-host "nuke_directory - END - [$dir_to_nuke]"
}