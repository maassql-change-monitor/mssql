function git_repo_exists ( $repo_base_path )
{
    [bool]$ret_exists = $false
    $repo_base_path_info = ( New-Object System.IO.DirectoryInfo $repo_base_path )
    if ( $repo_base_path_info.Exists -eq $true )
    {
      $git_repo_path_info = ( New-Object System.IO.DirectoryInfo "$repo_base_path\.git" )
      if ( $git_repo_path_info.Exists -eq $true )
      {
        $ret_exists = $true
      }  
    }
    return $ret_exists 
}