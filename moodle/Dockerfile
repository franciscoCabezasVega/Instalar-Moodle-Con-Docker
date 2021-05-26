# Docker LAMP Moodle-install
FROM centos:7 

# Dockerfile for moodle instance. more dockerish version of https://github.com/sergiogomez/docker-moodle
# Volume to persist the information of moodledata
VOLUME ["/var/moodledata"]

# Exposing the ports of Apache and TCP
EXPOSE 80 443

# Indicating the container that is not interactive
ENV DEBIAN_FRONTEND=noninteractive

# Database info and other connection information derrived from env variables. See readme.
# Set ENV Variables externally Moodle_URL should be overridden.
ENV MOODLE_URL=http://localhost \
    MYSQL_DATABASE=moodle \
    DB_ENV_MYSQL_DATABASE=moodle \
    MYSQL_ROOT_PASSWORD=admin \
    MYSQL_USER=moodleuser \
    DB_ENV_MYSQL_USER=moodleuser \
    MYSQL_PASSWORD=admin \
    DB_ENV_MYSQL_PASSWORD=admin \
    DB_PORT_3306_TCP_ADDR=DB \
    MOODLE_LANGUAGE=es

# Enable when using external SSL reverse proxy
# Default: false
ENV SSL_PROXY false

# Copying file of foreground apache2
COPY cd ..; ./config/foreground.sh /etc/apache2/foreground.sh

# Moodle requirements to install 
RUN yum update && \
    yum -y install mysql-client pwgen python-setuptools curl git unzip apache2 php nano \
    php-gd libapache2-mod-php postfix wget supervisor php-pgsql curl libcurl4 vim \
    libcurl3-dev php-curl php-xmlrpc php-intl php-mysql git-core php-xml php-mbstring php-zip php-soap cron php-ldap

# Dowload Moodle from official page 
RUN cd /var/tmp; curl -O https://download.moodle.org/download.php/direct/stable311/moodle-latest-311.tgz && \ 
	tar zxvf moodle-latest-311.tgz; mv /var/tmp/moodle/* /var/www/html && \ 
	chown -R www-data:www-data /var/www/html && \
	rm /var/www/html/index.html && \
	chmod +x /etc/apache2/foreground.sh

# Copying files to specified path
COPY cd ..; ./vars/moodle-config.php /var/www/html/config.php

# Moodle configuration file cron and permission
COPY cd ..; ./config/moodlecron /etc/cron.d/moodlecron
RUN chmod 0644 /etc/cron.d/moodlecron

# Enable SSL, moodle requires it
RUN a2enmod ssl && a2ensite default-ssl  
# if using proxy dont need actually secure connection

# Defining working directory
WORKDIR var/www/html
	 
# Cleanup, this is ran to reduce the resulting size of the image.
RUN yum clean autoclean && yum autoremove -y && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/lib/dpkg/* /var/lib/cache/* /var/lib/log/*
	
# Entrypoint sets the command and parameters that will be executed first when a container is run.
ENTRYPOINT ["/etc/apache2/foreground.sh"]