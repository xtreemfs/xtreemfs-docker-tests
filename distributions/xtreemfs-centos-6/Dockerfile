FROM centos:6
MAINTAINER Christoph Kleineweber <kleineweber@zib.de>

ENV DEBIAN_FRONTEND noninteractive

RUN yum install -y wget
RUN cd /etc/yum.repos.d/ && wget http://download.opensuse.org/repositories/home:/xtreemfs:/unstable/CentOS_6/home:xtreemfs:unstable.repo
RUN yum install -y xtreemfs-client
RUN yum install -y xtreemfs-server

ADD test.sh /
RUN chmod +x test.sh
