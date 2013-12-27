function item_completed ( $changes, $scrptd )
{

    <# $null = ( item_completed_debug $changes $scrptd ) #>

    $change_detected = $false
    $_output = ""

    foreach ( $item in $changes.GetEnumerator() )
    {
        if ($item.Name -eq 'has_changes')
        {
            if ($item.Value -eq $true)
            {
               $change_detected = $true
            }
        }
        if ($item.Name -eq 'filtered_output')
        {
            $_output = $item.Value
        }        
    }

    $null = ( log_this "$($scrptd.scm_name) --- CHANGE_DETECTED=$change_detected ----------------" )

    $null = ( (schema_checkin_as_html $scrptd) >> (html_file_showing_every_check) )
    if ( $change_detected -eq $true )
    {
        $null = ( change_detected $scrptd $_output)
    }
    return $null
}
