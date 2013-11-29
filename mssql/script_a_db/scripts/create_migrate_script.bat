ECHO ENTERING : %0%
SET PARAM_MSSQL_VER=%1%

REM ------SETUP COMMON FOR MIGRATION SCRIPTS-------------------------------------------------------------------
SET SWITCHES_MIGRATE_SCRIPT=%SWITCHES%
set OPTIONS_MIGRATE_SCRIPT=%options%,UseClrUdtToStringForClrMigration
SET SQ_MIGRATE=%SQ% %SWITCHES_MIGRATE_SCRIPT% %OPTIONS_MIGRATE_SCRIPT%
REM -------------------------------------------------------------------------


SET SWITCH_FILTER_FOR_MIGRATION_SCRIPT=/filter:%FILTERS_DIR%sql_compare_filter_for_migration_script_%PARAM_MSSQL_VER%.scpf

REM -------------------------------------------------------------------------
SET REPORT_FILE_NAME=%BASE_REPORT%_migration_script_%PARAM_MSSQL_VER%.html
SET CONSOLE_OUTPUT_REPORT=%CONSOLE_OUTPUT%.report_on_migration_script_%PARAM_MSSQL_VER%.log.txt
ECHO Report on Migrate script for %PARAM_MSSQL_VER% to be written to: %REPORT_FILE_NAME%
%SQ_REPORT% %CONSOLE_OUTPUT_REPORT% /report:%REPORT_FILE_NAME% %SWITCH_FILTER_FOR_MIGRATION5_SCRIPT%   
REM -------------------------------------------------------------------------



ECHO BASE_MIGRATE = 
ECHO %BASE_MIGRATE%
REM -------------------------------------------------------------------------
ECHO MIGRATE_SCRIPT_NAME 
ECHO %MIGRATE_SCRIPT_NAME% 
SET MIGRATE_SCRIPT_NAME=%BASE_MIGRATE%_%PARAM_MSSQL_VER%.sql
ECHO MIGRATE_SCRIPT_NAME 
ECHO %MIGRATE_SCRIPT_NAME%
SET CONSOLE_OUTPUT_MIGRATION_SCRIPT=%CONSOLE_OUTPUT%.migration_script_%PARAM_MSSQL_VER%.log.txt
IF NOT [%PARAM_MSSQL_VER%]==[all_objects] (
ECHO Migrate script for %PARAM_MSSQL_VER% to be written to: %MIGRATE_SCRIPT_NAME%
%SQ_MIGRATE% %CONSOLE_OUTPUT_MIGRATION_SCRIPT% /ScriptFile:%MIGRATE_SCRIPT_NAME% %SWITCH_FILTER_FOR_MIGRATION_SCRIPT%
REM -------------------------------------------------------------------------
	)



ECHO EXITING : %0%