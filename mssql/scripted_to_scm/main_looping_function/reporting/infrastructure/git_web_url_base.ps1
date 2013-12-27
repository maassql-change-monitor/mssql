function git_web_url_base ($scrptd)
{
    return "$(web_server_url)/gitweb/gitweb.cgi?p=$($scrptd.'instance').$($scrptd.'dbname')/.git"
}