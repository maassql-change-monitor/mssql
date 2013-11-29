$SCRIPT:scripted_db_directory="F:\sql_compare\scripted_dbs"
$SCRIPT:scm_db_script_directory_base="F:\scm_databases"
$SCRIPT:scm_db_script_directory_template="{base}\{server_instance}\{database}"
$SCRIPT:code_common_directory="$here\..\common"
$SCRIPT:main_log_file= "$($SCRIPT:scm_db_script_directory_base)\scm.log"

$SCRIPT:scripted_db_directory_must_sit_idle_for_x_minutes = 5

$SCRIPT:git_bin_path="C:\Program Files (x86)\Git\bin"
$SCRIPT:seven_zip_bin_path="C:\Program Files\7-Zip\"



<# synch frequency #>
$seconds_in_minute = 60
$seconds_in_an_hour = ( $seconds_in_minute * 60 )
$SCRIPT:synch_every_X_seconds =  ( $seconds_in_an_hour / 2 )

<# stop the script after X hours #>
$SCRIPT:stop_the_script_after_X_hours = 24