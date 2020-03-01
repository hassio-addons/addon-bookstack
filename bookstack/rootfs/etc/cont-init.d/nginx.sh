#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: Bookstack
# This file configures nginx
# ==============================================================================
declare admin_port
declare certfile
declare dns_host
declare keyfile

admin_port=$(bashio::addon.port 80)
if bashio::var.has_value "${admin_port}"; then
    bashio::config.require.ssl

    if bashio::config.true 'ssl'; then
        certfile=$(bashio::config 'certfile')
        keyfile=$(bashio::config 'keyfile')

        mv /etc/nginx/servers/direct-ssl.disabled /etc/nginx/servers/direct.conf
        sed -i "s#%%certfile%%#${certfile}#g" /etc/nginx/servers/direct.conf
        sed -i "s#%%keyfile%%#${keyfile}#g" /etc/nginx/servers/direct.conf
    else
        mv /etc/nginx/servers/direct.disabled /etc/nginx/servers/direct.conf
    fi
    sed -i "s/%%port%%/80/g" /etc/nginx/servers/direct.conf
fi

dns_host=$(bashio::dns.host)
sed -i "s/%%dns_host%%/${dns_host}/g" /etc/nginx/includes/resolver.conf
