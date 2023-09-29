FROM kong:3.4.0-ubuntu

USER root

#Install with local folder
COPY plugins/jwt-claims /usr/local/share/lua/5.1/kong/plugins/jwt-claims

# Install from Github relases
# ADD --chown=kong https://github.com/devmasx/kong-jwt-claims-plugin/releases/download/v0.1.0/handler.lua \
#   https://github.com/devmasx/kong-jwt-claims-plugin/releases/download/v0.1.0/schema.lua \
#   /usr/local/share/lua/5.1/kong/plugins/jwt-claims/

USER kong
ENV KONG_PLUGINS=bundled,jwt-claims
