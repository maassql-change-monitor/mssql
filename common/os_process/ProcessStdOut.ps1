$GLOBAL:stream = ""
Function Global:ProcessStd ( $stream, $string )
{
    [datetime]$dttm = (Get-Date)
    $dttm.ToUniversalTime().ToString("yyyyMMddzz HH:MM:SS")
    $GLOBAL:stream += "$([Environment]::NewLine)$dttm     |     $stream     |     $string"
}
