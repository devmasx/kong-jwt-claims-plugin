FROM kong:3.4.0-ubuntu

USER root
COPY plugins/ /usr/local/share/lua/5.1/kong/plugins/

USER kong
