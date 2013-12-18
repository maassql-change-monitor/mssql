$timer  = New-Object Timers.Timer
$timer.Interval = 500
$job = Register-ObjectEvent -inputObject $timer -eventName Elapsed -sourceIdentifier Timer.Random -Action {$random = Get-Random -Min 0 -Max 100}




$job.gettype().fullnameSystem.Management.Automation.PSEventJob
$job | format-list -property *

State         : Running
Module        : __DynamicModule_6b5cbe82-d634-41d1-ae5e-ad7fe8d57fe0
StatusMessage :
HasMoreData   : True
Location      :
Command       : $random = Get-Random -Min 0 -Max 100
JobStateInfo  : Running
Finished      : System.Threading.ManualResetEvent
InstanceId    : 88944290-133d-4b44-8752-f901bd8012e2
Id            : 1
Name          : Timer.Random
ChildJobs     : {}...

$timer.Enabled = $true
& $job.module {$random}60
& $job.module {$random}47