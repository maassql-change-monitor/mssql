Function copy_to_scm ($scm_db_path, $scripted_db_directory, $captured_on, $server_n_instance, $database_name)
{
    scripted_to_scm_log "copy to scm - copy new - BEGIN"
    scripted_to_scm_log "`$captured_on                      =[$captured_on]"
    scripted_to_scm_log "`$server_n_instance                =[$server_n_instance]"
    scripted_to_scm_log "`$database_name                    =[$database_name]"
    scripted_to_scm_log "`$scripted_db_directory.FullName   =[$($scripted_db_directory.FullName)]"
    scripted_to_scm_log "`$scm_db_path                      =[$scm_db_path]"    
    $null = (Copy-Item  -Container -Recurse -Force -LiteralPath:($scripted_db_directory.FullName) -Destination:$scm_db_path)
    scripted_to_scm_log "copy to scm - copy new - DONE"
}


