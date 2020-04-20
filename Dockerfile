FROM opensuse/tumbleweed

RUN zypper install --no-confirm --no-recommends \
         openSUSE-release-appliance-docker \
         apache2-utils \
         python3-pip \
         shadow \
         util-linux \
    && zypper clean --all \
    && pip install --no-cache-dir \
         Radicale \
         bcrypt \
         passlib \
    && groupadd radicale \
    && useradd -b /srv -m -g radicale radicale \
    && mkdir -m 0750 /etc/radicale \
    && chgrp radicale /etc/radicale

COPY entrypoint.sh /usr/local/bin
COPY config /root/config

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["radicale", "--foreground", "--config", "/etc/radicale/config"]
