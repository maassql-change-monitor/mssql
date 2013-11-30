import-module -force ".\nuke_file.ps1"

$SCRIPT:files_in_use = New-Object System.Collections.ArrayList

<# 
.EXAMPLE
  nuke_directory -dir_to_nuke:'F:\scm_databases\.git\' -names_to_leave:$null
#>
function nuke_directory ($dir_to_nuke, $names_to_leave)
{
    if ( $names_to_leave -eq $null ) { $names_to_leave = @() }

    $SCRIPT:files_in_use = $null
    $SCRIPT:files_in_use = New-Object System.Collections.ArrayList

    write-host "nuke_directory - remove previous=[$dir_to_nuke] - BEGIN "
    $dir_to_remove_info = ( New-Object System.IO.DirectoryInfo $dir_to_nuke )

    if ( ( $dir_to_remove_info.Exists ) -eq $true )
    {
        <# try simply deleting the directory #>
        if ( $dir_to_remove_info.isReadOnly -eq $true )
        {
          $dir_to_remove_info.isReadOnly = $false  
        }

        $delete_one_at_time = $true

        if ( $names_to_leave.Count -eq 0 ) 
        {        
          $delete_one_at_time = $false
        }

        if ( $delete_one_at_time -eq $false )
        {
          try 
          {
            $dir_to_remove_info.Delete($true)   
          }
          catch 
          { 
            $delete_one_at_time = $true
          }
        }

        if ( $delete_one_at_time -eq $true )
        {
          $null = (nuke_directory_one_file_at_a_time -dir_to_nuke:$dir_to_nuke  -names_to_leave:$names_to_leave)
        }        
    }
    else 
    {
        write-host "nuke_directory - remove previous=[$dir_to_nuke] - was not there to remove"
    }
    write-host "nuke_directory - remove previous=[$dir_to_nuke] - DONE"
}


function nuke_directory_one_file_at_a_time($dir_to_nuke, $names_to_leave)
{
  write-host "nuke_directory_one_file_at_a_time - remove previous=[$dir_to_nuke] - BEGIN"   
  foreach($item in Get-ChildItem -LiteralPath:$dir_to_nuke)
  {
    if (( $names_to_leave -contains ($item.name)) -eq $false )
    {
      nuke_file -file_to_nuke:$item.FullName
    }
  } 
  if ($SCRIPT:files_in_use.Count -gt 0 )
  {
    Write-Host "There were [$($SCRIPT:files_in_use.Count)] files in use.  `$SCRIPT:files_in_use holds a list of them.  You could always re-run the command.  Best suggestion is to do that once, then if there are still files in use, access the list and start hound dogging what's holding the files open."
  }
  write-host "nuke_directory_one_file_at_a_time - remove previous=[$dir_to_nuke] - DONE"  
}