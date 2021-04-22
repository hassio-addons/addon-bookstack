#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: Bookstack
# This file configures nginx
# ==============================================================================

if bashio::var.is_empty "$(bashio::addon.port 80)"; then
    bashio::log.warning "No host port is configured, please ensure a port is"
    bashio::log.warning "set for external access to function"
fi

bashio::config.require.ssl
bashio::var.json \
    certfile "$(bashio::config 'certfile')" \
    keyfile "$(bashio::config 'keyfile')" \
    ssl "^$(bashio::config 'ssl')" \
    | tempio \
        -template /etc/nginx/templates/direct.gtpl \
        -out /etc/nginx/servers/direct.conf

