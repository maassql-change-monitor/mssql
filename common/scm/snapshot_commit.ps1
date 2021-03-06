function snapshot_commit
{
    [cmdletbinding()]
    Param (
        [Parameter(Mandatory=$true)][string]            $local_repository_path
        , [Parameter(Mandatory=$true)][string]          $local_snapshot_path
        , [Parameter(Mandatory=$false)][string]         $snapshot_commit_message
        , [Parameter(Mandatory=$false)] [switch]        $remove_snapshot_path
        , [Parameter(Mandatory=$false)] [switch]        $clear_repository_after_commit
        , [Parameter(Mandatory=$false)][string]         $snapshot_tag
    )


    Set-StrictMode -Version:Latest
    $GLOBAL:ErrorActionPreference               = "Stop"

    if ($snapshot_commit_message -eq $null -or $snapshot_commit_message -eq '')
    {
      $snapshot_commit_message = "snapshot_commit : To local repo=[$local_repository_path]. Snapshot path=[$local_snapshot_path]."  
    }

    if ($local_repository_path -eq $null -or $local_repository_path -eq "" ) { throw "`$local_repository_path may not be null or blank.=[$local_repository_path]."}

    $repo_base_path = (Split-Path -Path:$local_repository_path)
    $repo_name = (Split-Path -Path:$local_repository_path -Leaf)

    $null = ( create_repository -repository_name:$repo_name -repository_path:$repo_base_path )

    $null = ( clear_repository $local_repository_path )

    write-host "copying to repository | BEGIN"
    $null = ( Copy-Item  -Container -Recurse -Force -Path:"$local_snapshot_path\*" -Destination:"$local_repository_path\" )
    write-host "copying to repository | END"

    [Hashtable]$changes = ( commit_to_local_repository $local_repository_path -msg:$snapshot_commit_message )

    <# even if nothing changes, record that a snapshot was done #>
    $null = ( git_exe_2 -path_to_repository:$local_repository_path -arg_string:"tag -a $snapshot_tag -m $snapshot_tag" )

    if ( $clear_repository_after_commit -eq $true )
    {
        $null = ( clear_repository $local_repository_path )
    }

    $null = ( pack_repository $local_repository_path )

    if ($remove_snapshot_path -eq $true)
    {
        write-host "clearing snapshot directory | BEGIN"
        $null = ( nuke_directory -dir_to_nuke:$local_snapshot_path ) 
        write-host "clearing snapshot directory | END"  
    }

    return $changes
}