function loop_status ($started, $stop_at)
{
    $tspan=New-TimeSpan $started  (Get-Date);
    $diff_hours=($tspan).hours;
    write-host "Been running $(($tspan).days) days $($diff_hours) hours $(($tspan).minutes) minutes $(($tspan).seconds) seconds. $(Get-Date).  We plan on stopping at $stop_at."   
}