$SCRIPT:code_common_directory=( Resolve-Path "$my_dir\..\..\common" )
$SCRIPT:my_exit_loop_flag_file="$($my_dir)\flag_file.stop"


$SCRIPT:scripted_db_directory_base_path="F:\sql_compare\scripted_dbs"
$SCRIPT:scm_db_script_directory_base="F:\scm_databases"
$SCRIPT:scm_db_script_name="{server_instance}.{database}"
$SCRIPT:scripted_db_directory_must_sit_idle_for_x_minutes = 5
$SCRIPT:directories_to_grab_at_a_time=2;

<# synch frequency #>
$seconds_in_minute = 60
$seconds_in_an_hour = ( $seconds_in_minute * 60 )
$SCRIPT:synch_every_X_seconds = 10 # ( $seconds_in_an_hour / 2 )

<# stop the script after X hours #>
$SCRIPT:stop_the_script_after_X_hours = 24

write-console "vars has been included....."