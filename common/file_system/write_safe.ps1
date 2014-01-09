function write_safe ( $file_name, $to_write )
{
    [boolean]$ret_written = $false

    try 
        {
            $to_write >> ( $file_name )  
            $ret_written = $true 
        }
    catch 
        {
            $to_log = "Exception whilst attempting to write to $file_name.  "
            $ex = $null
            if ($_.Exception -ne $null)
            {
                $ex = $_.Exception
            }
            if ( $ex -ne $null)
            {
                $to_log += $ex.Message
            }
            <# possible infinite loops #>
            <# log_this $to_log #>
        }

    return $ret_written
}