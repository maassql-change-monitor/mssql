[string]$GLOBAL:stream = ""
Function Global:ProcessStd ( $stream, $string )
{
    [datetime]$dttm = (Get-Date)
    $dttm.ToUniversalTime().ToString("yyyyMMddzz HH:MM:SS")
    $new_line = "$([Environment]::NewLine)$dttm     |     $stream     |     $string"
    write-output $new_line
    scripted_to_scm_log $new_line
    [string]$GLOBAL:stream = "$($GLOBAL:stream)$new_line"
    return $null
}
