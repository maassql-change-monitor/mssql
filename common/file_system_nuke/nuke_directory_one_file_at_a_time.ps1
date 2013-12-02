function nuke_directory_contents($dir_to_nuke, $names_to_leave)
{
  write-debug "nuke_directory_contents - BEGIN - [$dir_to_nuke]"   
  $dir_to_remove_info = ( directory_info_prepared_for_strike $dir_to_nuke )
  if ( $dir_to_remove_info.Exists -eq $true )
  {
    foreach($item in Get-ChildItem -LiteralPath:$dir_to_nuke)
    {
      if (( $names_to_leave -contains ($item.name)) -eq $false )
        {
          if ($item.PSIsContainer -eq $true)
            {
              $null = ( nuke_directory -dir_to_nuke:$item.FullName -names_to_leave:$names_to_leave  )
            }
          else 
            {
              $null = ( nuke_file -fi_file_to_nuke:$item )   
            }
        }
    } 
    if ($SCRIPT:files_in_use.Count -gt 0 )
    {
      write-debug "There were [$($SCRIPT:files_in_use.Count)] files in use.  `$SCRIPT:files_in_use holds a list of them.  You could always re-run the command.  Best suggestion is to do that once, then if there are still files in use, access the list and start hound dogging what's holding the files open."
    }    
  }
  write-debug "nuke_directory_contents - END - [$dir_to_nuke]" 
}