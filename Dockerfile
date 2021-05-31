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
    MOODLE_LANGUAGE=es_co

# Enable when using external SSL reverse proxy
# Default: false
ENV SSL_PROXY false

# Moodle requirements to install 
RUN yum install httpd -y && \
    yum install policycoreutils-python curl nano cron \
        pwgen python-setuptools git unzip apache2 \
        postfix wget supervisor libcurl4 vim \
        libcurl3-dev git-core -y && \
    yum update -y

# Install PHP
RUN yum install epel-release yum-utils -y && \
    yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y && \
    yum-config-manager --enable remi-php73 -y && \
    yum install php php-common php-opcache php-mcrypt php-cli php-gd php-curl php-mysqlnd php-xml php-xmlrpc \ 
        php-mbstring php-pecl-zip php-intl php-soap -y

# Setting and select the DB
RUN yum install mysql-client php-mysql php-pgsql -y

# Dowload Moodle from official page 
RUN cd /var/tmp; curl -O https://download.moodle.org/download.php/direct/stable311/moodle-latest-311.tgz && \
    tar zxvf moodle-latest-311.tgz; mv /var/tmp/moodle/* /var/www/html/ && \
    chown -R apache: /var/www/html/ && \
    mkdir /var/moodledata && \
    chown apache: /var/moodledata/ && \
    chmod -R 777 /var/moodledata && \
    sed -i 's/^/#&/g' /etc/httpd/conf.d/welcome.conf

# Copying files to specified path
COPY ./vars/moodle-config.php /var/www/html/config.php 
COPY ./vars/phpversion.php /var/www/html/phpversion.php
#COPY ./config/php.ini /etc/php.ini

# Moodle configuration file cron and permission
COPY ./config/moodlecron /etc/cron.d/moodlecron/
RUN chmod 0644 /etc/cron.d/moodlecron

# Defining working directory
WORKDIR /var/www/html

# Cleanup, this is ran to reduce the resulting size of the image.
RUN rm -rf /var/tmp/*

# Entrypoint sets the command and parameters that will be executed first when a container is run.
ENTRYPOINT ["/usr/sbin/httpd", "-D", "FOREGROUND"]