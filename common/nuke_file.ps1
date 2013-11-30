
function nuke_file($fi_file_to_nuke)
{
    try 
    {  
        if ( $fi_file_to_nuke.isReadOnly -eq $true )
        {
          $fi_file_to_nuke.isReadOnly = $false  
        }
        Remove-Item -LiteralPath:($item.FullName) -Force <# because (misleadingly) even with appropriate access, PermissionDenied errors are thrown if read only files exist within the directory being deleted, unless Force is specified. #>
    }
    catch [Exception]
    {
        $null = ( nuke_file_strategy $file_to_nuke $_.Exception )
    } 
    return $null  
}

function nuke_file_strategy($file_to_nuke, $nuke_exception)
{
    write-debug "nuke_file_strategy - remove previous=[$($file_to_nuke)] - tried removing and it errd.  Err=[$($nuke_exception.Message)]... "
    $fi_file_to_nuke = (New-Object System.IO.FileInfo $file_to_nuke)

    if ($fi_file_to_nuke.Exists -eq $true)
    {
        $throw = $true
        $file_is_in_use = $false
        $exception_Message = $nuke_exception.Message

        if ($exception_Message -like "*Cannot remove the item at *because it is in use.*" ) 
            {
                <# record it in a list of files, try again to delete it.#>
                $file_is_in_use = $true
                $throw = $false
            }
        if ($throw -eq $true)
            {
                throw $exception_Message
            }
        try 
        {
            Remove-Item -LiteralPath:($file_to_nuke) -Force 
        }
        catch [Exception]
        {
            <# Just try it, why not? #>
            try 
            {
                $fi_file_to_nuke.Delete() 
            }
            catch [Exception]
            {
                $throw = $true
                if ($file_is_in_use -eq $true) 
                    { 
                        $SCRIPT:files_in_use.Add($file_to_nuke)
                    }
                if ($throw -eq $true)
                    {
                        throw $_.Exception.Message
                    } 
            }  
        }  
    }  
    return $null  
}