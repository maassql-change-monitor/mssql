[string]$GLOBAL:stream = ""
Function Global:ProcessStd ( $stream, $string )
{
    [datetime]$dttm = (Get-Date)
    $dttm.ToUniversalTime().ToString("yyyyMMddzz HH:MM:SS")
    $new_line = "$([Environment]::NewLine)$dttm     |     $stream     |     $string"
    [string]$GLOBAL:stream = "$($GLOBAL:stream)$new_line"
    return $null
}
