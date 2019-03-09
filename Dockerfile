FROM arm32v5/debian:stretch-slim
MAINTAINER tibodut <tibodut@gmail.com>

ENV LC_ALL="C.UTF-8"

RUN \
    apt-get update -qq && \
    #apt-get install -qqy wget lame faad flac sox libio-socket-ssl-perl libnet-ssleay-perl && \
    apt-get install -qqy wget libgomp1 libio-socket-ssl-perl && \
    apt-get clean -qqy && \
\
:
RUN \
    # Install LMS \
    /bin/bash -c '\
        export DEBIAN_FRONTEND="noninteractive" && \
        OUT=$(wget -q --no-check-certificate -O - "http://downloads.slimdevices.com/nightly/index.php?ver=7.9") && \
        OS=$(dpkg --print-architecture) && \
        if [ "$OS" = "armhf" ]; then OS=arm; fi && \
        URL=$(echo $OUT | grep -oE "/[^\"]*logitechmediaserver_7\.9\.2~[0-9]{4,}_$OS\.deb") && \
        if [ -z "$URL" ]; then URL=$(echo $OUT | grep -oE "/[^\"]*logitechmediaserver_7\.9\.2~[0-9]{4,}_all\.deb"); fi && \
        if [ -z "$URL" ]; then exit 42; fi && \
        wget -q --no-check-certificate -O /tmp/lms.deb "http://downloads.slimdevices.com/nightly${URL}" && \
        dpkg -i /tmp/lms.deb && \
        rm /tmp/lms.deb \
    ' && \
:
RUN \
    mkdir /config /music && \
    chown squeezeboxserver:nogroup /config /music && \
\
    rm -rf /var/lib/apt/lists/* /var/cache/apt/* /tmp/* /var/tmp/*

VOLUME /config /music
EXPOSE 3483 3483/udp 9000 9090

USER squeezeboxserver
ENTRYPOINT ["squeezeboxserver"]
CMD ["--prefsdir", "/config/prefs", "--logdir", "/config/logs", "--cachedir", "/config/cache"]
