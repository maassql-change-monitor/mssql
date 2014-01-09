function shared_write_to_common_file ( $file_name, $to_write )
{
    $try_max = 50 <# for a total of 5 seconds #>
    while ( (write_safe $file_name $to_write) -eq $false ){
        $try_max -= 1;
        if ($try_max -le 0)
        {
            break
            <# swallow the write ? REALLY ? #>
        }
        start-sleep -MilliSeconds:100
    }
}