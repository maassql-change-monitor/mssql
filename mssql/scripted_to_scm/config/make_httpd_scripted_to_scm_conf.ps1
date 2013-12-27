function make_httpd_scripted_to_scm_conf
    $httpd_conf=@"
# Config to make the Git html docu available through Apache.
Alias /msssql_scm "$($SCRIPT:httpd_html_loc)"
<Directory "$($SCRIPT:httpd_html_loc)">
    Options +Includes +Indexes +MultiViews
    Require all granted
</directory>    
"@
    $httpd_conf > $SCRIPT:httpd_conf_file
}
