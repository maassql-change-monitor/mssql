function nuke_file($fi_file_to_nuke)
{
    if ($fi_file_to_nuke -eq $null) {throw "`$fi_file_to_nuke may not be null."}

    try 
    {  
        if ( $fi_file_to_nuke.isReadOnly -eq $true )
        {
          $fi_file_to_nuke.isReadOnly = $false  
        }
        Remove-Item -LiteralPath:($fi_file_to_nuke.FullName) -Force <# because (misleadingly) even with appropriate access, PermissionDenied errors are thrown if read only files exist within the directory being deleted, unless Force is specified. #>
    }
    catch [Exception]
    {
        $null = ( nuke_file_strategy $fi_file_to_nuke.FullName $_.Exception )
    } 
    return $null  
}