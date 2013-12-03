Function create_repository 
{

    [cmdletbinding()]
    Param (
        [Parameter(Mandatory=$true)]    [string]        $repository_name
        ,[Parameter(Mandatory=$true)]   [string]    $repository_path
    )

    write-host "create_repository | BEGIN"

    # https://help.github.com/articles/create-a-repo
    if ((Test-Path -LiteralPath:$repository_path) -eq $false )      { throw "The repository_path must exist before calling this function.  repository_path=[$repository_path]."}

    $full_path = "$repository_path\$repository_name"
    if ((Test-Path $full_path -IsValid) -eq $false)                 { throw "The full repository path is not a valid path.  It is OK if the path does not exist.  That's not the problem here.  The problem is that this path just isnot a file system path.  Full repo path=[$full_path]."}
    
    if ((git_repo_exists $full_path ) -eq $false )    
        { 
            if ((Test-Path -LiteralPath:$full_path) -eq $false )  
            {
                New-Item -path:$full_path -type:directory
            }
            
            cd $full_path

            $git_args = @('init' ) # , '--quiet' )
            $null = ( git_exe -path_to_repository:$full_path -da_args:$git_args  )
            
            "$repository_name" >> README
            
            if ((git_repo_exists $full_path ) -eq $false ) 
            {
                throw "After create_repository command, no .git directory was found.  `$repository_name=[$repository_name].  `$repository_path=[$repository_path]."
            } 

            commit_to_local_repository $full_path "first commit"  
        }
    $repository_name > "$full_path/.git/description"



    write-host "create_repository | END | $full_path"
    return $full_path 
}