# Dowload Moodle from official page 
RUN cd /var/tmp; curl -O https://download.moodle.org/download.php/direct/stable311/moodle-latest-311.tgz && \ 
	tar zxvf moodle-latest-311.tgz; mv /var/tmp/moodle/* /var/www/html && \ 
	chown -R www-data:www-data /var/www/html && \
	rm /var/www/html/index.html && \
	chmod +x /etc/apache2/foreground.sh