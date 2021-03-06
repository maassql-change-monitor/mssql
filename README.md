maassql-change-monitor/mssql
=============================
This is a Monitoring Tool based on the Polling approach.  Its purpose is to tell you what changed, and about when it changed.

This tool monitors changes to Microsoft Sql Server Databases.

It does this by scripting the database's settings and schema to flat text files, then, adding / commiting those flat files to a git repository.

Change Control Monitoring
=========================
* Meaning, you watch for changes
* Two approaches:
  * Event driven
    * something happens in the environment
    * typically events are built into the environment
    * typically requires monitoring software to be a part of the monitored environment
    * if an event is missed, we cannot observe it occurred
    * typically provides the most precise information - how someone did x at what time.
  * Polling
    * timed intervals
    * frequency is determined by usefulness.  Use the widest useful frequency.  Is it useful for me to know what changed in the last millesecond?  second?  minute?  sixth hour?  quarter hour?  day?
    * typically, information is much less precise than event driven observation.  We usually don't get the how, the who, or what time.
    * typically, information is much more accurate.
    * Often, knowing what changed, close to when it changed --> gets us to 80% of our needs
* This project
  * Why not use the Event driven model?
    * Event driven is less reliable
      * traces can be turned off 
      * triggers can be disabled
    * Event driven is less desirable 
      * changes are missed 
      * huge space requirements 
      * requires installations on the monitored server
  * Also, let's be honest:
    * I wanted to decide what is important and what is not important
    * If I have to change production, I have to get a ton more people involved
    * I wanted to do it my way

How does it work?
==============================
* Create scripts of your database
* Monitor :
  * waits until the scripts are untouched for 5 minutes
  * {scm_db_script_directory_base}/{instance}/{database}/
    * deletes the contents, except for the .git folder
    * from {scripted_db_directory_base_path}/{scripted_db}, copies in the scripted db
  * adds / commits the scripts to the local git repository, putting in the date of scripting, {datetime_scripted}
  * deletes the contents of {scripted_db_directory_base_path}/{scripted_db}

Database Scripts:
==================
* represent / are generated from a live database.
* Script folder name must follow naming convention
  * <code>{instance_name}\_!\_{database_name}\_!\_{datetime_scripted}\_!\_{some short random string}</code>
  * remove characters incompatible with windows file system names
  * no name quotes, no brackets
  * Example : MyServer\_in\_Dallas\_!\_archive\_!\_20140107T114515710\_!\_744C97C4 
    * Server Name   : MyServer_in_Dallas
    * Database Name : archive
    * Date Scripted : 15.710 seconds after 11:45 AM on January 7th, 2014.
    * Random String : 744C97C4
* Could be generated by:
  * MS MSSQL libraries : SSMS DMO, SMO, Larry or whatever MS is calling it these days 
  * Red Gate's SQL Compare
  * Another third party tool
  * Your own custom code
* MUST be generated using the same settings everytime.  IE - if you put all your objects into 1 file for the first run, don't split them out the second run, and then expect that you will be able to effectively see what has changed.
* Are intially scripted into {scripted_db_directory_base_path}


Installation / Configuration - Overview
===================================
* Redgate Sql Compare - for creating database scripts
* Git for Windows - for recording state of database script
* Apache Web Server - for serving :
  * GitWeb - a web based interface to Git
  * Reports - HTML files which contain different views of the data
* maassql-change-monitor/mssql
* Automation
  * scripting of database
  * checkin of database script



Installation - 3rd party apps
==================
* [Git for Windows](http://git-scm.com/download/win)
  * During installation, allow Git Bash to have full interactivity
* Apache Web Server
  * [Manual Installation](http://httpd.apache.org/docs/2.2/platform/windows.html)
  * -or, my preferred method- Use a [BitNami Application Installer](http://bitnami.com/stacks)
    * Installs the full stack - everything needed for the app, front to back
    * For example, maybe you could use a bug tracker like [RedMine](http://bitnami.com/stack/redmine)
* GitWeb for Windows
  * You ALREADY have it installed!!!
  * [Configuration Instructions](https://git.wiki.kernel.org/index.php/MSysGit:GitWeb)
* Configure Apache to serve up documents from msssql_scm
  * the exact .conf syntax may be different on your apache installation, so google, don't freak, if it doesn't work right away.
  * in {apache_app_directory}/conf/httpd.conf
  * Same place, if you followed the instructions for GitWeb for Windows, that you setup the include of httpd-git.conf

          Include "{APP_BASE_PATH}/maassql-change-monitor/mssql/mssql/scripted_to_scm/config/httpd_scripted_to_scm.conf"
* Install RedGate's sql compare
  * http://www.red-gate.com/products/sql-development/sql-compare/
  * You can use MS Scripting Objects or some other product.  You'll just have to make changes to the scripts as needed.

Installation - maassql-change-monitor/mssql 
==================
* These instruction are for use with [Base or Git Bash ( MINGW32 )](http://git-scm.com/download/win)
* Open a terminal window
* Paste in this ( changing values as appropriate )

        APP_BASE_PATH="/c/DBATools/"
        REPO_URL="git@github.com:maassql-change-monitor/mssql.git"
        YOUR_GIT_HUB_USER_NAME="maass-sql"
        YOUR_EMAIL="maassql@gmail.com"
    
* Paste this code in to check that the variables are set correctly

        ECHO ${APP_BASE_PATH}
        ECHO ${REPO_URL}
        ECHO ${YOUR_GIT_HUB_USER_NAME}
        ECHO ${YOUR_EMAIL}
    
* Now, this code will get you a copy of the repository

        cd ${APP_BASE_PATH}
        mkdir maassql-change-monitor
        cd maassql-change-monitor
        mkdir mssql
        cd mssql
        git clone --branch tiny_changes_to_elves --verbose --progress --recurse-submodules --config user.name="${YOUR_GIT_HUB_USER_NAME}" --config user.email="${YOUR_EMAIL}" ${REPO_URL} "${APP_BASE_PATH}/maassql-change-monitor/mssql/"
        git config user.name "${YOUR_GIT_HUB_USER_NAME}"
        git config user.email "${YOUR_EMAIL}"
    
* And you can use this code to check up on your new local Git Repo  

        git config --list
        ls -al

Configuration
==================
* Some specific details can be found under the directory : {APP_BASE_PATH}\maassql-change_monitor\mssql\scripted_to_scm\Setup
* Create folders
  * Choose a big drive.  You will have to figure out what big means.  For me, I had 2000 + databases, that meant 225 GB.  Really, I figured that out by trial and error.
  * scripted_dbs   - {scripted_db_directory_base_path} - the location where the scripts of databases will be written
  * scm_databases  - {scm_db_script_directory_base} - the location where the script of databases will be copied.  The location where the git repositories will be kept.
  * code_folder    - {APP_BASE_PATH} - the location where you will store the code which runs this processing
* Fill in values as defined in {APP_BASE_PATH}\maassql-change_monitor\mssql\scripted_to_scm\config\
  * scripted_to_scm.psm1.vars.ps1
  * http_scripted_to_scm.conf
* Automate the scripting of the databases
  * via MS Sql Agent
  * see example job at : {APP_BASE_PATH}\maassql-change_monitor\mssql\scripted_to_scm\Setup
* Automate the checkin of the scripts
  * via Windows Task Scheduler
  * see example task at : {APP_BASE_PATH}\maassql-change_monitor\mssql\scripted_to_scm\Setup





