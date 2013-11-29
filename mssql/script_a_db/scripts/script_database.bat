@echo off

SET SQ="C:\Program Files (x86)\Red Gate\SQL Compare 10\sqlcompare.exe" /verbose /force

ECHO Sql compare :
ECHO %SQ%

SET WHAT_DB=/server1:%SVR% /database1:%DB%
ECHO What db :
ECHO %WHAT_DB%
 
SET AS_WHO=/username1:%USER% /password1:%PASSWORD%
ECHO As who :
ECHO %AS_WHO%

SET m_scripts=/makescripts:'%DB_SCRIPT_FOLDER%' 
echo we will write to this folder: %DB_SCRIPT_FOLDER%


%SQ% %WHAT_DB% %AS_WHO% %m_scripts%

