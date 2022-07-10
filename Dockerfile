FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
     openconnect \
     python3-gi gir1.2-gtk-3.0 gir1.2-webkit2-4.0 libcairo2-dev pkg-config python3-pip \
     supervisor sudo \
    && pip install https://github.com/dlenski/gp-saml-gui/archive/master.zip \
    && pip install pproxy[accelerated] \
    && apt-get clean autoclean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/

COPY docker-entrypoint.sh /
COPY supervisord.conf /etc/
COPY interactive-openconnect.sh /
RUN chmod +x /interactive-openconnect.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 1080
ENV DISPLAY :0