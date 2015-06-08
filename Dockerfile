FROM ubuntu:14.04
MAINTAINER A.Shilokhvostov <github@shilli.ru>

ENV HOME /root
ADD src /tmp

RUN     chmod -v +x /tmp/*sh && sync && sleep 1 \
        && /tmp/prepare.sh \
        && /tmp/system_services.sh \
        && /tmp/utilities.sh \
        && /tmp/cleanup.sh

ENTRYPOINT ["/sbin/my_init","--"]
