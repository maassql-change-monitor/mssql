#-------------------------------------------------------#
# Script:      ExecNonQuery.psm1                        # 
# Created By:  Wesley Brown                             # 
# Created On:  09/12/2013                               # 
# Description: Execute a command against a SQL database # 
#              without returning a result (NonQuery).   # 
#-------------------------------------------------------# 
   
# Performs an ExecuteNonQuery command against the server and database specified
function ExecNonQuery { 
    [CmdletBinding()] 
    param(
        [Parameter(Position=0, Mandatory=$true)] [string]$ServerInstance, 
        [Parameter(Position=1, Mandatory=$false)] [string]$Database, 
        [Parameter(Position=2, Mandatory=$false)] [string]$Query, 
        [Parameter(Position=3, Mandatory=$false)] [string]$Username, 
        [Parameter(Position=4, Mandatory=$false)] [string]$Password, 
        [Parameter(Position=5, Mandatory=$false)] [Int32]$QueryTimeout=600, 
        [Parameter(Position=6, Mandatory=$false)] [Int32]$ConnectionTimeout=15, 
        [Parameter(Position=7, Mandatory=$false)] [ValidateScript({test-path $_})] [string]$InputFile
    ) 
    if ($InputFile) 
    { 
        $filePath = $(resolve-path $InputFile).path 
        $Query =  [System.IO.File]::ReadAllText("$filePath") 
    } 
 
    if (!$Query)
    { 
        # One or more parameters didn't contain values. 
        Throw "ExecNonQuery function called with no command text."
    }
 
    if (!$Database)
    { 
        # One or more parameters didn't contain values. 
        $Database = "master"
    }
 
    $conn=new-object System.Data.SqlClient.SQLConnection 
      
    if ($Username) { 
        $ConnectionString = "Server={0};Database={1};User ID={2};Password={3};Trusted_Connection=False;Connect Timeout={4}" -f $ServerInstance,$Database,$Username,$Password,$ConnectionTimeout
    } 
    else { 
        $ConnectionString = "Server={0};Database={1};Integrated Security=True;Connect Timeout={2}" -f $ServerInstance,$Database,$ConnectionTimeout
    } 
  
    $conn.ConnectionString=$ConnectionString
    #Following EventHandler is used for PRINT and RAISERROR T-SQL statements. Executed when -Verbose parameter specified by caller 
    if ($PSBoundParameters.Verbose) { 
        $conn.FireInfoMessageEventOnUserErrors=$true
        $handler = [System.Data.SqlClient.SqlInfoMessageEventHandler] {Write-Verbose "$($_)"} 
        $conn.add_InfoMessage($handler) 
    }
 
    try {
        $conn.Open()
        $cmd=new-object system.Data.SqlClient.SqlCommand($Query,$conn) 
        $cmd.CommandTimeout=$QueryTimeout
        $cmd.ExecuteNonQuery() 
        $conn.Close() 
    } 
    catch { 
        # An generic error occurred somewhere in the try area. 
        Throw $error[0]
    } 
    finally { 
        # Determine if the connection was opened. 
        if ($cnn.State -eq "Open") 
        { 
            # Close the currently open connection. 
            $conn.Close() 
        }
    }
}