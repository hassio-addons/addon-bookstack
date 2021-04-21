#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: Bookstack
# This file configures nginx
# ==============================================================================

bashio::config.require.ssl
bashio::var.json \
    certfile "$(bashio::config 'certfile')" \
    keyfile "$(bashio::config 'keyfile')" \
    ssl "^$(bashio::config 'ssl')" \
    | tempio \
        -template /etc/nginx/templates/direct.gtpl \
        -out /etc/nginx/servers/direct.conf

