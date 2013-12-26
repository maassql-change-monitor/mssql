function url_base ($scrptd)
{
    return "http://nghsdemosql:81/gitweb/gitweb.cgi?p=$($scrptd.'instance').$($scrptd.'dbname')/.git"
}