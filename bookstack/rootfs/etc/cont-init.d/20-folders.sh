#!/usr/bin/with-contenv bashio
# ==============================================================================
# Community Hass.io Add-ons: Bookstack
# This file configures required folders
# ==============================================================================

if ! bashio::fs.directory_exists "/data/mysql"; then
    bashio::log "Creating MySql directory"
    mkdir /data/mysql
    chown mysql:mysql /data/mysql
fi
if ! bashio::fs.directory_exists "/data/bookstack/uploads"; then
    bashio::log "Creating uploads directory"
    mkdir -p /data/bookstack/uploads
fi
if ! bashio::fs.directory_exists "/data/bookstack/files"; then
    bashio::log "Creating files directory"
    mkdir -p /data/bookstack/files
fi
if ! bashio::fs.directory_exists "/data/bookstack/images"; then
    bashio::log "Creating images directory"
    mkdir -p /data/bookstack/images
fi
rm -r /var/www/bookstack/storage/uploads/files
rm -r /var/www/bookstack/storage/uploads/images
rm -r /var/www/bookstack/public/uploads
ln -s /data/bookstack/files /var/www/bookstack/storage/uploads/files
ln -s /data/bookstack/images /var/www/bookstack/storage/uploads/images
ln -s /data/bookstack/uploads /var/www/bookstack/public/uploads 
