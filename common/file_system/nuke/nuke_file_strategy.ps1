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
                write-debug "AWW, we are going to have to throw an error.  File=[$file_to_nuke]."
                throw $exception_Message
            }
        try 
        {
            Remove-Item -LiteralPath:($file_to_nuke) -Force 
        }
        catch [Exception]
        {
            try 
            {
                $fi_file_to_nuke.Delete() <# Just try it, why not? #>
            }
            catch [Exception]
            {
                $throw = $true
                if ($file_is_in_use -eq $true) 
                    { 
                        write-warning "     Aww.  Found a locked file, we can't delete it.  File=[$file_to_nuke]."
                        $SCRIPT:files_in_use.Add($file_to_nuke)
                    }
                if ($throw -eq $true)
                    {
                        write-warning "     AWW, we are going to have to throw an error.  File=[$file_to_nuke]."
                        throw $_.Exception.Message
                    } 
            }  
        }  
    }  
    return $null  
}