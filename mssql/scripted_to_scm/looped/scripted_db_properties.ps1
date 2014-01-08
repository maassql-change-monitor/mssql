function scripted_db_properties
{
    [cmdletbinding()]
    param ( [parameter(Mandatory=$true)]  [System.IO.DirectoryInfo] $scripted_db_directory

    , [parameter(Mandatory=$true)] [string] $scm_db_script_name
    , [parameter(Mandatory=$true)] [string] $scm_db_script_directory_base ) 

    $ret_hash = @{}

    $folder_name = $scripted_db_directory.Name 
    $split_up = $folder_name.Split("!")
    if ( $split_up.Count -ne 4 )
    {
        $err_msg = "The scripted_db_directory we received did not follow our naming conventions.... directory we received=[$($scripted_db_directory.FullName)].  split_up.Count=[$($split_up.Count)]"
        log_this "scripted_to_scm - $err_msg..........$split_up"
        throw $err_msg
    }
    #parse the variables from the scripted_db_directory
    $server_n_instance = ($split_up[0]).TrimEnd('_')
    $database_name = ($split_up[1]).TrimEnd('_').TrimStart('_')
    $captured_on = ($split_up[2]).TrimEnd('_').TrimStart('_')

    $ret_hash.Add("path", $scripted_db_directory.FullName) 
    $ret_hash.Add("folder", $folder_name) 
    $ret_hash.Add("instance", $server_n_instance) 
    $ret_hash.Add("dbname", $database_name)
    $ret_hash.Add("dttm", $captured_on)  
    $ret_hash.Add("dttm_human", ( scripted_checked_date $captured_on ).ToString('u') )  
    $ret_hash.Add("dttm_date", ( scripted_checked_date $captured_on ).ToString("yyyy-MM-dd HH:mm:ss.FFFFFFF"))  

    $scm_name = ($scm_db_script_name.Replace("{server_instance}", $($ret_hash.'instance')).Replace("{database}", $($ret_hash.'dbname')))
    $ret_hash.Add("scm_name", $scm_name) 
    $scm_db_path = "$($scm_db_script_directory_base)\$scm_name"
    $ret_hash.Add("scm_db_path", $scm_db_path) 

    log_this "
        instance            =[$($ret_hash.'instance')]
        dbname              =[$($ret_hash.'dbname')]
        dttm                =[$($ret_hash.'dttm')]
        dttm_human          =[$($ret_hash.'dttm_human')]
        folder              =[$($ret_hash.'folder')]
        scm_name            =[$($ret_hash.'scm_name')]
        path                =[$($ret_hash.'path')]
        scm_db_path         =[$($ret_hash.'scm_db_path')]
"
    return $ret_hash
}


function scripted_checked_date ($captured_on_from_folder_name)
{
    $checked_as_date = [System.Convert]::ToDateTime( ($captured_on_from_folder_name).insert(4, '.').insert(7, '.').insert(13, ':').insert(16, '.').Substring(0,22) )
    return $checked_as_date
}