@echo off

REM ---------------------------------------------------
REM			This script accepts 2 directories
REM				previously scripted using RedGate SQL Compare
REM				This script then compares the two directories
REM				The result is 3 files:
REM					* RedGate's html output of a comparison between the 2 databases
REM					** all Objects
REM 				** Objects / settings as one would do for comparing 2005+ databases 
REM					* SQL file for making database 2 the same as database 1 ( using 2005+ settings )
REM ---------------------------------------------------

REM to test......
REM E:\sql_compare\scripts\compare_script_directories.bat E:\sql_compare\scripted_dbs\ASPWDB2_BUL_ExitCare_20131008T125940923_AF5271B4 E:\sql_compare\scripted_dbs\ASPWDB2_CREN_ExitCare_20131008T130744480_6E5D5403


REM -------------------------------------------------------------------------
SET DIR1=%1%
SET DIR2=%2%

SET COMP1=/scripts1:%DIR1%
ECHO script dir 1 :
ECHO %COMP1%

SET COMP2=/scripts2:%DIR2%
ECHO script dir 2 :
ECHO %COMP2%

SET COMPARISON_ID_IN_DB=%3%
IF [%COMPARISON_ID_IN_DB%]==[] (
	SET COMPARISON_ID_IN_DB=000TEST000
	)

SET MSSQL_VER=%4%
IF [%MSSQL_VER%]==[] (
	SET MSSQL_VER=2005
	)



REM -------------------------------------------------------------------------







REM ------SETUP Directories-------------------------------------------------------------------
SET SCRIPTS_DIR=E:\sql_compare\scripts\
SET FILTERS_DIR=E:\sql_compare\configs\
SET CONSOLE_DIR=E:\sql_compare\logs\
SET REPORTS_DIR=F:\sql_compare\comparison_reports\
SET MIGRATE_SCRIPT_DIR=F:\sql_compare\comparison_reports\
REM -------------------------------------------------------------------------


REM ------Get today's date for use in file names ------------------
call %SCRIPTS_DIR%\get_the_now_for_file.bat


REM ------SETUP BASE_FILE_NAMES-------------------------------------------------------------------
SET BASE_FILE_NAME=%the_now_for_file%_%COMPARISON_ID_IN_DB%
SET BASE_CONSOLE=%CONSOLE_DIR%%BASE_FILE_NAME%.out
SET BASE_REPORT=%REPORTS_DIR%%BASE_FILE_NAME%_report
SET BASE_MIGRATE=%MIGRATE_SCRIPT_DIR%%BASE_FILE_NAME%_migrate

ECHO BASE_MIGRATE = 
ECHO %BASE_MIGRATE%


REM ------Setup Console Output Switch-------------------------------------------------------------------
ECHO Console Output to be written to:%CONSOLE_OUTPUT_FILE_NAME_BASE%
SET CONSOLE_OUTPUT=/Out:%BASE_CONSOLE%
REM -------------------------------------------------------------------------

REM -----Setup Common Objects--------------------------------------------------------------------
set options=/Options:IgnoreComments,IgnoreConstraintNames,DecryptPost2KEncryptedObjects,IgnoreFillFactor,IgnoreWhiteSpace,IncludeDependencies,IgnoreFileGroups,IgnoreUserProperties,IgnoreWithElementOrder,IgnoreDatabaseAndServerName
set SWITCHES=%COMP1% %COMP2% /LogLevel:Verbose /ShowWarnings /Include:Identical
REM -------------------------------------------------------------------------


REM -----Setup SQL Compare--------------------------------------------------------------------
SET SQ="C:\Program Files (x86)\Red Gate\SQL Compare 10\sqlcompare.exe" /verbose 
ECHO Sql compare :
ECHO %SQ%
REM -------------------------------------------------------------------------


REM ------SETUP COMMON FOR REPORTS-------------------------------------------------------------------
SET REPORT_SWITCHES=%SWITCHES% /ReportType:Interactive %REPORT%
SET REPORT_OPTIONS=%options% 
SET SQ_REPORT=%SQ% %REPORT_SWITCHES% %REPORT_OPTIONS%
REM -------------------------------------------------------------------------

call %SCRIPTS_DIR%\create_migrate_script.bat all_objects

call %SCRIPTS_DIR%\create_migrate_script.bat %MSSQL_VER%

REM When using an XML file note that --> you cannot specify any other switches on the command line except /verbose or /quiet