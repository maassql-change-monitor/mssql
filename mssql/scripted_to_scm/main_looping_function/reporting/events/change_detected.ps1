function change_detected ( $scrptd, $_output)
{
    $null = ( (schema_checkin_as_html $scrptd) >> (html_file_showing_changed_databases) )

    <# store output for later use.  #>
    $SCRIPT:changes_observed["$($scrptd.'instance').$($scrptd.'dbname')"] = @{
        "scrptd" = $scrptd ;
        "output" = $_output     
    }
}