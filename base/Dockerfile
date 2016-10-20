FROM debian:wheezy
MAINTAINER meteorup.cn

ENV METEORD_DIR /opt/meteord
COPY scripts $METEORD_DIR

RUN bash $METEORD_DIR/lib/install_base.sh
RUN bash $METEORD_DIR/lib/cleanup.sh
