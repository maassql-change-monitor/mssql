Function commit_to_local_repository ($path_to_commit, $msg)
{
    write-host "commit_to_local_repository- BEGIN | $path_to_commit"

    $has_changes = $false
    $filtered_output = ""
    $git_output = ""

    $git_output = ( git_exe_2 -path_to_repository:$path_to_commit -arg_string:"add --all $path_to_commit"  )
    $git_output += ( git_exe_2 -path_to_repository:$path_to_commit -arg_string:"commit -a -m '$msg' " )  # --message='$($msg)' 

    Foreach ($line in $git_output.Split([Environment]::NewLine))
    {
        if ((ignore_line $line) -eq $false )
        {
            $filtered_output += "$([Environment]::NewLine)$line"
            if (changes_seen $line)
                {
                    $has_changes = $true
                }
        } 
    } 
    
    [hashtable]$ret_hash = @{
        "has_changes"=$has_changes ; 
        "filtered_output" = $filtered_output ;
    }

    write-host "commit_to_local_repository- DONE | $path_to_commit"
    return ( $ret_hash )
}

Function ignore_line ( $line )
{
    if ( $line -eq '' ) {return $true}
    if ( $line -eq $null ) { return $true }
    <#
    "warning: LF will be replaced by CRLF in Tables/dbo.user_mstr.sql." -match "(warning: LF will be replaced by CRLF in) (.*)"
    "The file will have its original line endings in your working directory." - match "The file will have its original line endings in your working directory." 
    #>
    if ( $line -match ".*(warning: LF will be replaced by CRLF in) (.*)" ) { return $true }
    if ( $line -match ".*The file will have its original line endings in your working directory."  ) { return $true }
    return $false
}

Function changes_seen ($line)
{
    <#
    "[master 0fe588d] 'automation'" -match "\[(.*) (.*)\] ('automation')"
    "2 files changed, 4 insertions(+), 4 deletions(-)" -match "(.*) files changed, (.*) insertions\(\+\), (.*) deletions\(-\)"    
    #>
    if ( $line -match ".*\[(.*) (.*)\] ('automation')" ) { return $true }
    if ( $line -match ".*(.*) files changed, (.*) insertions\(\+\), (.*) deletions\(-\)"  ) { return $true }
    return $false
}

