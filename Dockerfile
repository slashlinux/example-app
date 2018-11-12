FROM ubuntu:latest
MAINTAINER NewstarCorporation

RUN apt-get -y upgrade
RUN apt-get update

# install apache server
RUN apt-get install -y apache2
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install apache2 libapache2-mod-php5 php5-mysql php5-gd php-pear php-apc php5-curl php5-ldap curl lynx-cur
# Enable apache mods.
RUN php5enmod openssl
RUN a2enmod php5
RUN a2enmod rewrite
COPY index.html /var/www/html
CMD [“/usr/sbin/apache2”, “-D”, “FOREGROUND”]
EXPOSE 80

# install ssh server
RUN apt-get install -y  openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:screencast' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
