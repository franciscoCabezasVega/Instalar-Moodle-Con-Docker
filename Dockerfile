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
RUN yum update -y && \
    yum install httpd -y && \
    yum install policycoreutils-python curl nano cron -y

# Dowload Moodle from official page 
RUN curl -O https://download.moodle.org/download.php/direct/stable311/moodle-latest-311.tgz && \
    tar xf moodle-latest-311.tgz -C /var/www/html/ && \
    chown -R apache: /var/www/html/moodle/ && \
    mkdir /var/www/moodledata && \
    chown apache: /var/www/moodledata/

# Install PHP
RUN yum install php-curl php-mbstring php-opcache php-xml php-gd php-intl php-xmlrpc php-soap php-pecl-zip -y

# Setting and select the DB
RUN yum install mysql-client php-mysql -y 
# RUN yum -y install php-pgsql

# Copying files to specified path
COPY ./vars/moodle-config.php /var/www/html/config.php/

# Moodle configuration file cron and permission
COPY ./config/moodlecron /etc/cron.d/moodlecron/
RUN chmod 0644 /etc/cron.d/moodlecron

# Defining working directory
WORKDIR /var/www/html