FROM ubuntu:latest
MAINTAINER NewstarCorporation

RUN apt-get -y upgrade
RUN apt-get update

# install apache server
RUN apt-get install -y apache2
# Enable apache mods.
COPY index.html /var/www/html
CMD /usr/sbin/apache2ctl -D FOREGROUND

EXPOSE 80

# install ssh server
RUN apt-get install -y  openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:p4r4gin4' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PermitRootLogin/PermitRootLogin/g' /etc/ssh/sshd_config
RUN /etc/init.d/ssh restart 

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
