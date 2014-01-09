[string]$GLOBAL:stream = ""
Function Global:ProcessStd ( $stream, $string )
{
    [string]$dttm = (Get-Date).ToUniversalTime().ToString("u")
    $frmtd_output = "$([Environment]::NewLine)$dttm     |     $stream     |     $string"
    $null=( log_this $frmtd_output 'os_process' )
    [string]$GLOBAL:stream = "$($GLOBAL:stream)$frmtd_output"
    return $null
}