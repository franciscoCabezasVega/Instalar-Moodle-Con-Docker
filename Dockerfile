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
COPY ./config/foreground.sh /var/www/html/foreground.sh/

# Moodle requirements to install 
RUN yum install epel-release -y && \
    yum update -y && \
    yum install httpd -y && \
    rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm && \
    yum install curl mysql-client mod_php71w php71w-common php71w-mbstring php71w-xmlrpc php71w-soap php71w-gd php71w-xml php71w-intl php71w-mysqlnd php71w-cli php71w-mcrypt php71w-ldap -y

# Dowload Moodle from official page 
RUN curl -O https://download.moodle.org/download.php/direct/stable311/moodle-latest-311.tgz && \ 
	tar zxvf moodle-latest-311.tgz -C /var/www/html && \
    chown -R root:root /var/www/html/moodle && \
    chmod -R 755 /var/www/html/foreground.sh

# Copying files to specified path
COPY ./vars/moodle-config.php /var/www/html/config.php/

# Moodle configuration file cron and permission
COPY ./config/moodlecron /etc/cron.d/moodlecron/
RUN chmod 0644 /etc/cron.d/moodlecron

# Defining working directory
WORKDIR /var/www/html
	
# Entrypoint sets the command and parameters that will be executed first when a container is run.
ENTRYPOINT ["/etc/apache2/foreground.sh"]