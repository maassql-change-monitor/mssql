$SCRIPT:files_in_use = $null
$SCRIPT:files_in_use = New-Object System.Collections.ArrayList

<#
.SYNOPSIS
    This should only be called at the initial entry point to the module
#>
Function clear_files_in_use_list
{
    $SCRIPT:files_in_use = $null
    $SCRIPT:files_in_use = ( New-Object System.Collections.ArrayList )
}


Function files_in_use_list
{
  return ( $SCRIPT:files_in_use )  
}