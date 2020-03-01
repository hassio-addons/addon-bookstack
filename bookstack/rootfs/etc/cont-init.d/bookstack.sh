#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: Bookstack
# This file validates config, creates the database and configures the app key
# ==============================================================================
declare host
declare key
declare password
declare port
declare username

if bashio::config.has_value 'remote_mysql_host'; then
  if ! bashio::config.has_value 'remote_mysql_database'; then
    bashio::exit.nok \
      "Remote database has been specified but no database is configured"
  fi

  if ! bashio::config.has_value 'remote_mysql_username'; then
    bashio::exit.nok \
      "Remote database has been specified but no username is configured"
  fi

  if ! bashio::config.has_value 'remote_mysql_password'; then
    bashio::log.fatal \
      "Remote database has been specified but no password is configured"
  fi

  if ! bashio::config.exists 'remote_mysql_port'; then
    bashio::exit.nok \
      "Remote database has been specified but no port is configured"
  fi
else
  if ! bashio::services.available 'mysql'; then
     bashio::log.fatal \
       "Local database access should be provided by the MariaDB addon"
     bashio::exit.nok \
       "Please ensure it is installed and started"
  fi

  host=$(bashio::services "mysql" "host")
  password=$(bashio::services "mysql" "password")
  port=$(bashio::services "mysql" "port")
  username=$(bashio::services "mysql" "username")

  bashio::log.warning "Bookstack is using the Maria DB addon"
  bashio::log.warning "Please ensure this is included in your backups"
  bashio::log.warning "Uninstalling the MariaDB addon will remove any data"

  bashio::log.info "Creating database for Bookstack if required"
  mysql \
    -u "${username}" -p"${password}" \
    -h "${host}" -P "${port}" \
    -e "CREATE DATABASE IF NOT EXISTS \`bookstack\` ;"
fi

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
ln -sf /dev/stderr /var/www/bookstack/storage/logs/laravel.log

# Create API key if needed
if ! bashio::fs.file_exists "/data/bookstack/appkey.txt"; then
  bashio::log.info "Generating app key"
  key=$(php /var/www/bookstack/artisan key:generate --show)
  echo "${key}" > /data/bookstack/appkey.txt
  bashio::log.info "App Key generated: ${key}"
fi
