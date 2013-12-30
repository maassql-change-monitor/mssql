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

    $null = ( log_this "$($scrptd.scm_name) --- checkin completed -- CHANGED=$change_detected ----------------" )

    $html = (schema_checkin_as_html $scrptd)
    $null = ( $html  >> ( html_file_report_every_check_by_date_recorded ) )
    $null = ( $html  >> ( html_file_report_every_check_by_date_checked ( scripted_checked_date $scrptd ) ) )

    if ( $change_detected -eq $true )
    {
        $null = ( change_detected $scrptd $_output)
    }
    
    return $null
}
