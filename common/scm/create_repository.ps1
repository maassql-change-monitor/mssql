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
                md $full_path
            }
            
            cd $full_path

            $git_args = @('init', '--quiet' )
            $init_results = (& $SCRIPT:git_path $git_args) 
            write-host "$init_results"
            "$repository_name" >> README
            
            commit_to_local_repository ($path_to_commit, "first commit")             
        }

    write-host "create_repository | END | $full_path"
    return $full_path 
}