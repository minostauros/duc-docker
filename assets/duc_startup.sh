#!/bin/bash
# Make sure we're not confused by old, incompletely-shutdown httpd
# context after restarting the container.  httpd won't start correctly
# if it thinks it is already running.
rm -rf /run/httpd/*

db_dir="/duc/db/"
for file in "${db_dir}"*.db; do
	[ -f "${file}" ] || break
	filename="$(basename "${file}")"
	filename="${filename%.*}"
	echo "#!/bin/sh
	/usr/local/bin/duc cgi $DUC_CGI_OPTIONS -d ${file}" > /var/www/duc/"${filename}".cgi
	chmod +x /var/www/duc/"${filename}".cgi
done

/usr/sbin/apache2ctl -D FOREGROUND