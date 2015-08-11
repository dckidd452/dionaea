# dionaea dockerfile by MO 
#
# VERSION 0.42
FROM ubuntu:14.04.3
MAINTAINER MO

# Setup apt
RUN echo "deb http://ppa.launchpad.net/honeynet/nightly/ubuntu trusty main" >> /etc/apt/sources.list
RUN echo "deb-src http://ppa.launchpad.net/honeynet/nightly/ubuntu trusty main" >> /etc/apt/sources.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys FC8C70BBE667E4FB0F42916511C832A6A6131AE4
RUN apt-get update -y
RUN apt-get dist-upgrade -y
ENV DEBIAN_FRONTEND noninteractive

# Install packages 
RUN apt-get install -y supervisor dionaea-phibo

# Setup user, groups and configs
RUN addgroup --gid 2000 tpot 
RUN adduser --system --no-create-home --shell /bin/bash --uid 2000 --disabled-password --disabled-login --gid 2000 tpot
RUN mkdir -p /data/dionaea/log /data/dionaea/bistreams /data/dionaea/binaries /data/dionaea/rtp /data/dionaea/wwwroot
RUN chmod 760 -R /data && chown tpot:tpot -R /data
ADD dionaea.conf /etc/dionaea/
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Clean up 
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Start dionaea
CMD ["/usr/bin/supervisord"]
