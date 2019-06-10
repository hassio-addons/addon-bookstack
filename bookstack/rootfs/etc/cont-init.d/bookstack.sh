#!/usr/bin/with-contenv bashio
# ==============================================================================
# Community Hass.io Add-ons: Bookstack
# This file creates/upgrades the MYSQL db and configures the app key
# ==============================================================================
if ! bashio::fs.directory_exists "/data/bookstack/uploads"; then
    bashio::log "Creating uploads directory"
    mkdir -p /data/bookstack/uploads
    chown nginx:nginx /data/bookstack/uploads
fi
if ! bashio::fs.directory_exists "/data/bookstack/files"; then
    bashio::log "Creating files directory"
    mkdir -p /data/bookstack/files
    chown nginx:nginx /data/bookstack/files
fi
if ! bashio::fs.directory_exists "/data/bookstack/images"; then
    bashio::log "Creating images directory"
    mkdir -p /data/bookstack/images
    chown nginx:nginx /data/bookstack/images
fi
rm -r /var/www/bookstack/storage/uploads/files
rm -r /var/www/bookstack/storage/uploads/images
rm -r /var/www/bookstack/public/uploads
ln -s /data/bookstack/files /var/www/bookstack/storage/uploads/files
ln -s /data/bookstack/images /var/www/bookstack/storage/uploads/images
ln -s /data/bookstack/uploads /var/www/bookstack/public/uploads 

declare key
# Create API key if needed
if ! bashio::fs.file_exists "/data/bookstack/appkey.txt"; then
	bashio::log.info "Generating app key"
	key=$(php /var/www/bookstack/artisan key:generate --show)
	echo "${key}" > /data/bookstack/appkey.txt
	bashio::log.info "App Key generated: ${key}"
fi
ln -sf /dev/stderr /var/www/bookstack/storage/logs/laravel.log

