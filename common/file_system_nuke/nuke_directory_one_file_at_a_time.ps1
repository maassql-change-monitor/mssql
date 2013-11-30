function nuke_directory_one_file_at_a_time($dir_to_nuke, $names_to_leave)
{
  write-host "nuke_directory_one_file_at_a_time - BEGIN - [$dir_to_nuke]"   
  foreach($item in Get-ChildItem -LiteralPath:$dir_to_nuke)
  {
    if (( $names_to_leave -contains ($item.name)) -eq $false )
      {
        if ($item.PSIsContainer -eq $true)
          {
            $null = ( nuke_directory -dir_to_nuke:$item.FullName -names_to_leave:$names_to_leave )
          }
        else 
          {
            $null = ( nuke_file -fi_file_to_nuke:$item )   
          }
      }
  } 
  if ($SCRIPT:files_in_use.Count -gt 0 )
  {
    Write-Host "There were [$($SCRIPT:files_in_use.Count)] files in use.  `$SCRIPT:files_in_use holds a list of them.  You could always re-run the command.  Best suggestion is to do that once, then if there are still files in use, access the list and start hound dogging what's holding the files open."
  }
  write-host "nuke_directory_one_file_at_a_time - END - [$dir_to_nuke]" 
}