function nuke_directory ($dir_to_nuke, $names_to_leave)
{

    if ( $names_to_leave -eq $null ) { $names_to_leave = @() }

    write-host "nuke_directory - remove previous=[$dir_to_nuke] - BEGIN "
    $dir_to_remove_info = ( New-Object System.IO.DirectoryInfo $dir_to_nuke )
    if ( ( $dir_to_remove_info.Exists ) -eq $true )
    {
        write-host "nuke_directory - remove previous=[$($dir_to_remove_info.FullName)] - about to remove... "
        #$dir_to_remove_info.Delete($true)  <# Remove-Item gives better error messages #>
        try 
        {
            foreach($item in Get-ChildItem -LiteralPath:($dir_to_remove_info.FullName))
            {
              if (( $names_to_leave -contains ($item.name)) -eq $false )
              {
                Remove-Item -LiteralPath:($item.FullName) -Recurse
              }
            }   
        }
        catch [Exception]
        {
           if ($_.Exception.Message -like "*Cannot remove the item at *because it is in use.*" ) 
           {
                write-host "nuke_directory - remove previous=[$($dir_to_remove_info.FullName)] - tried removing and it errd.  Err=[$($_.Exception.Message)]... "
                write-host "nuke_directory - trying to remove each file individually at a time"
                $locked_files = New-Object System.Collections.ArrayList
                foreach ($file_to_remove In dir_to_remove_info.EnumerateFiles("*", SearchOption.AllDirectories))
                {
                    try
                    {
                        if ( $file_to_remove.Exists() -eq $true ) { $file_to_remove.Delete() }
                    }
                    catch [Exception]
                    {
                       if ($_.Exception.Message -like "*Cannot remove the item at *because it is in use.*" ) 
                       { 
                            write-host "nuke_directory - remove individual file=[$($file_to_remove.FullName)] - tried removing and it errd.  Err=[$($_.Exception.Message)]...  Putting it in a list to attempt to remove in just a bit. " 
                            $locked_files.Add $file_to_remove.FullName
                       }
                       else { throw $_.Exception.Message }
                    }
                }
                dir_to_remove_info.Refresh()
                foreach ($file_to_remove In dir_to_remove_info.EnumerateFiles("*", SearchOption.AllDirectories))
                {
                    try
                    {
                        if ( $file_to_remove.Exists() -eq $true ) { $file_to_remove.Delete() }
                        $locked_files.Remove($file_to_remove.FullName)
                    }
                    catch [Exception]
                    {
                       if ($_.Exception.Message -like "*Cannot remove the item at *because it is in use.*" ) 
                       { 
                            write-host "nuke_directory - Second attempt to remove and individual file=[$($file_to_remove.FullName)] - tried removing and it errd.  Err=[$($_.Exception.Message)]... " 
                       }
                       else { throw $_.Exception.Message }
                    }
                }
           }
           else 
           {
              throw $_.Exception.Message
           } 
        } 
    }
    else 
    {
        write-host "nuke_directory - remove previous=[$dir_to_nuke] - was not there to remove"
    }
    write-host "nuke_directory - remove previous=[$dir_to_nuke] - DONE"
}