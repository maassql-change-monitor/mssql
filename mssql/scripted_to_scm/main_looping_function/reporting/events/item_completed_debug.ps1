function item_completed_debug ( $changes, $scrptd )
{
    write-debug "----------------------------"
    write-debug "$($changes | format-table | out-string)"
    write-debug "----------------------------"
    write-debug "$($changes | get-member | out-string)"
    write-debug "----------------------------"
    write-debug "contains has_changes key=[$($changes.ContainsKey("has_changes"))]"
    write-debug "----------------------------"

    foreach ( $item in $changes.GetEnumerator() )
    {
        write-debug "*************************************************"
        write-debug "$($item | format-table | out-string)"
        write-debug "*************************************************"
        write-debug "$($item | get-member | out-string)"
        write-debug "*************************************************"       
    }



}