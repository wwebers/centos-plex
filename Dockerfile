FROM       centos:centos7
MAINTAINER Wolfram Webers <wolfram.webers@gmail.com> v-0.9.12.18.1520

# Fix broken link for /var/lock
RUN mkdir -p /run/lock/subsys

# Update RPM Packages
RUN yum -y update; yum clean all
RUN yum -y install initscripts; yum clean all
RUN rpm -Uvh https://downloads.plex.tv/plex-media-server/0.9.12.18.1520-6833552/plexmediaserver-0.9.12.18.1520-6833552.x86_64.rpm; echo 'avoiding error'
RUN mkdir /config && \
    mkdir /data && \
    chown plex:plex /config && \
    chown plex:plex /data 
VOLUME ["/config"]
VOLUME ["/data"]

ADD PlexMediaServer /etc/sysconfig/PlexMediaServer
ADD start.sh /start.sh

EXPOSE 32400

CMD ["/bin/bash", "/start.sh"]
