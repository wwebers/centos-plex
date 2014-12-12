FROM       centos:centos7
MAINTAINER Wolfram Webers <wolfram.webers@gmail.com> v-0.9.11.5.774-2014-12-12

# Fix broken link for /var/lock
RUN mkdir -p /run/lock/subsys

# Update RPM Packages
RUN yum -y update; yum clean all
RUN yum -y install initscripts; yum clean all

RUN rpm -Uvh https://downloads.plex.tv/plex-media-server/0.9.11.5.774-760cb52/plexmediaserver-0.9.11.5.774-760cb52.x86_64.rpm; echo 'avoiding error'

VOLUME ["/config"]

ADD PlexMediaServer /etc/sysconfig/PlexMediaServer

ADD start.sh /start.sh

EXPOSE 32400

CMD ["/bin/bash", "/start.sh"]
