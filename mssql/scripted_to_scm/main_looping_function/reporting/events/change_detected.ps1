function change_detected ( $scrptd, $_output)
{
    $html = (schema_checkin_as_html $scrptd)

    $null = ( $html  >> ( html_file_report_changes_detected_by_date_recorded ) )
    $null = ( $html  >> ( html_file_report_changes_detected_by_date_checked ( scripted_checked_date $scrptd ) ) )

    <# store output for later use.  #>
    $SCRIPT:changes_observed["$($scrptd.'instance').$($scrptd.'dbname')"] = @{
        "scrptd" = $scrptd ;
        "output" = $_output     
    }

    return $null
}






