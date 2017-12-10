
    BEGIN {
	print "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">"
	print "<!-- Automatically generated by GistMGR-FMT -->"
	print "<html xmlns=\"http://www.w3.org/1999/xhtml\">"
	print "  <head>"
	print "    <title>GistMGR-FMT Output</title>"
	print "    <meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" />"
	print "  </head>"
	print "  <body>"
	print "    <h1>GistMGR-FMT Output</h1>"
	print "    <table>"
	print "      <tbody>"
	print "        <tr><th>List</th><th>URL</th><th>Comment</th>"
    }

    {
	print "        <tr><td>"$1"</td><td><a href=\""$2"\">"$2"</a></td><td>"
	for (i=3; i <= NF; i++)
	    printf "%s ",$i
	print "</td></tr>"
    }

    END {
	print "      </tbody>"
	print "    </table>"
	print "  </body>"
	print "</html>"
    }