function snapshot_commit
{
    [cmdletbinding()]
    Param (
        [Parameter(Mandatory=$true)][string]            $local_repository_path
        , [Parameter(Mandatory=$true)][string]          $local_snapshot_path
        , [Parameter(Mandatory=$false)][string]         $snapshot_commit_message
        , [Parameter(Mandatory=$false)] [switch]        $remove_snapshot_path
        , [Parameter(Mandatory=$false)] [switch]        $clear_repository_after_commit
    )

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

    <# even if nothing changes, record that a snapshot was done #>
    "A snapshot commit was requested at:[$(Get-Date)].  The commit message was:[$($snapshot_commit_message)]." >> "$local_repository_path\aaaaaaaaaa_i_was_here_snapshot_commit.log"

    $null = ( commit_to_local_repository $local_repository_path -msg:$snapshot_commit_message )

    if ( $clear_repository_after_commit -eq $true )
    {
        $null = ( clear_repository $local_repository_path )
    }

    $null = ( pack_repository $local_repository_path )

    if ($remove_snapshot_path -eq $true)
    {
        $null = ( nuke_directory -dir_to_nuke:$scrptd.'path' )   
    }
}