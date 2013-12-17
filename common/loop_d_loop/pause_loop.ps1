function pause_loop ($seconds_to_pause)
{
    write-host ""
    write-host ""
    write-host ""
    write-host ""
    write-host "pausing until $((Get-Date).AddSeconds($seconds_to_pause)).......( $seconds_to_pause seconds ).........."
    $cntr = 0
    while ( $cntr -lt $seconds_to_pause )
    {
        $cntr += 2
        start-sleep -Seconds:2
        write-host "$cntr.." -NoNewline 
    }
    write-host ""
}