Function create_repository ($repository_name, $repository_path)
{
    # https://help.github.com/articles/create-a-repo

    $full_path = "$repository_path\$repository_name"
    write-host "create_repository | BEGIN | $full_path"


    if ((Test-Path $full_path -IsValid) -eq $false)                 { throw "The full repository path is invalid.  Full repo path=[$full_path]."}
    if ((Test-Path -LiteralPath:$repository_path) -eq $false )      { throw "The repository_path must exist before calling this function.  repository_path=[$repository_path]."}
    if ((Test-Path -LiteralPath:"$full_path\.git") -eq $false )    
        { 
            if ((Test-Path -LiteralPath:$full_path) -eq $false )  
            {
                New-Item -path:$full_path -type:directory
            }
            
            cd $full_path

            $git_args = @('init' ) # , '--quiet' )
            $null = ( git_exe -path_to_repository:$full_path -da_args:$git_args -quiet:$false )
            
            "$repository_name" >> README
            
            commit_to_local_repository $full_path "first commit"           
        }

    write-host "create_repository | END | $full_path"
    return $full_path 
}