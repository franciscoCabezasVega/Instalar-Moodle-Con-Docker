#!/bin/bash

echo "placeholder" > /var/moodledata/placeholder
chown -R apache:apache /var/www/moodledata
chmod -R 755 /var/www/moodledata

read pid cmd state ppid pgrp session tty_nr tpgid rest < /proc/self/stat
trap "kill -TERM -$pgrp; exit" EXIT TERM KILL SIGKILL SIGTERM SIGQUIT

#start up cron
/usr/sbin/cron

source /var/www/html/envvars
tail -F /var/log/httpd/* &
exec httpd -D FOREGROUND
