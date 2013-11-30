<# 
http://gallery.technet.microsoft.com/scriptcenter/79e3a8d3-fe68-4e6a-b41e-1fd22539e264
http://technet.microsoft.com/en-us/sysinternals/bb896655.aspx
#>

Function global:handle_exe()
{
        $my_fullname        = ($MyInvocation.MyCommand.Definition)
        $my_dir             = ( Split-Path $my_fullname )
        return "$my_dir\handle.exe"
}

Function global:GET-OpenFilePID() 
                { 
                                param 
                                ( 
                                [parameter(ValueFromPipeline=$true, 
                                                Mandatory=$true)] 
                                [String[]]$HandleData 
                                ) 
                                 
                                Process 
                                { 
                                                $OpenFile=New-Object PSObject -Property @{FILENAME='';ProcessPID='';FILEID=''} 
                                                 
                                                $StartPid=($HandleData[0] | SELECT-STRING 'pid:').matches[0].Index 
                                                $OpenFile.Processpid=$HandleData[0].substring($StartPid+5,7).trim() 
                                                 
                                                $StartFileID=($HandleData[0] | SELECT-STRING 'type: File').matches[0].Index 
                                                $OpenFile.fileid=$HandleData[0].substring($StartFileID+10,14).trim() 
                                                 
                                                $OpenFile.Filename=$HandleData[0].substring($StartFileID+26).trim() 
                                                Return $OpenFile 
                                } 
                } 
                 
Function global:GET-Openfile() 
{ 
[Cmdletbinding()] 
param 
                (  
                [parameter(Mandatory=$True, 
                ValueFromPipeline=$True)] 
                [String[]]$Filename 
                 
                ) 
                 
                Process 
                { 
                        If ( ! (TEST-LocalAdmin) ) { Write-Host 'Need to RUN AS ADMINISTRATOR first'; Return 1 } 
                        IF ( ! ($Filename) ) { Write-Host 'No Filename or Search Parameter supplied.' } 
                        $HANDLEAPP="& '$(handle_exe)'" 
                        $Expression=$HANDLEAPP+' '+$Filename 
                         
                        $OPENFILES=(INVOKE-EXPRESSION $Expression) -like '*pid:*' 
                         
                        $Results=($OPENFILES | GET-openfilepid) 
         
                        Return $results 
                } 
} 
 
Function global:Close-Openfile() 
{ 
[CmdletBinding(SupportsShouldProcess=$true)] 
Param( 
                [parameter(Mandatory=$True, 
                                ValueFromPipelineByPropertyName=$True)] 
                                [string[]]$ProcessPID, 
                [parameter(Mandatory=$True, 
                                ValueFromPipelinebyPropertyName=$True)] 
                                [string[]]$FileID, 
                [parameter(Mandatory=$false, 
                                ValueFromPipelinebyPropertyName=$True)] 
                                [String[]]$Filename 
                ) 
                 
                Process 
                { 
                        $HANDLEAPP="& '$(handle_exe)'"                 
                        $Expression=$HANDLEAPP+' -p '+$ProcessPID[0]+' -c '+$FileID[0]+' -y' 
                                if ( $PSCmdlet.ShouldProcess($Filename) )  
                                                { 
                                                INVOKE-EXPRESSION $Expression | OUT-NULL 
                                                If ( ! $LastexitCode ) { Write-host 'Successfully closed'} 
                                                } 
                } 
} 
 
Function global:TEST-LocalAdmin() 
                { 
                Return ([security.principal.windowsprincipal] [security.principal.windowsidentity]::GetCurrent()).isinrole([Security.Principal.WindowsBuiltInRole] "Administrator") 
                } 