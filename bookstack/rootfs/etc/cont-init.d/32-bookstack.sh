#!/usr/bin/with-contenv bashio
# ==============================================================================
# Community Hass.io Add-ons: Bookstack
# This file creates/upgrades the MYSQL db and configures the app key
# ==============================================================================
declare key
# Create API key if needed
if ! bashio::fs.file_exists "/data/bookstack/appkey.txt"; then
	bashio::log.info "Generating app key"
	key=$(php /var/www/bookstack/artisan key:generate --show)
	echo "${key}" > /data/bookstack/appkey.txt
	bashio::log.info "App Key generated: ${key}"
else
	key=$(cat /data/bookstack/appkey.txt)
fi
sed -i "s,APP_KEY=SomeRandomString,APP_KEY=${key},g" \
     /var/www/bookstack/.env

