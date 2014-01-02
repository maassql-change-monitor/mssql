function set_directory_read_only_false($dir_to_nuke)
{
  write-debug "set_directory_read_only_false - BEGIN - [$dir_to_nuke]"   
  $dir_to_remove_info = ( New-Object System.IO.DirectoryInfo $dir_to_nuke )
  $attributes = ($dir_to_remove_info.Attributes)
  if (($attributes -bAnd ([System.IO.FileAttributes]::ReadOnly)) -gt 0 )
  {
    write-debug "     Is set true.  Setting to False."  
    $attributes = RemoveAttribute(attributes, System.IO.FileAttributes.ReadOnly);
    System.IO.Directory.SetAttributes($dir_to_nuke, $attributes);
  }
  write-debug "set_directory_read_only_false - END - [$dir_to_nuke]"    
  return $null
}