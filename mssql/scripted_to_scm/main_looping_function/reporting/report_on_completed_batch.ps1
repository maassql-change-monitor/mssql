function report_on_completed_batch () 
{
    write-host "should we send an email summary?"
    $summary_email_body = ""
    foreach ($who in $SCRIPT:changes_observed.GetEnumerator())
    {
       $hash_output = $who.value
       $scrptd = $hash_output."scrptd"
       $_output = $hash_output."output"

       $summary_email_body += "$([Environment]::NewLine)$($who.key) = $(url_last_change $scrptd)"
    }
    if ($summary_email_body -ne '')
    {
        $summary_email_body = "
        
        Change Reports :         http://nghsdemosql:81/msssql_scm/

        Changes detected ==>  $([Environment]::NewLine)$summary_email_body"
        $null = (email_about_changes $summary_email_body  "Databases Changed" )
    }
}