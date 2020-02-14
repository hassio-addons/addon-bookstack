#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: Bookstack
# This file validates config, creates the database and configures the app key
# ==============================================================================

declare key

if bashio::config.has_value 'remote_mysql_host';then
	if ! bashio::config.has_value 'remote_mysql_database';then
		bashio::log.fatal \
		"Remote database has been specified but no database is configured"
		bashio::exit.nok
	fi
	if ! bashio::config.has_value 'remote_mysql_username';then
		bashio::log.fatal \
		"Remote database has been specified but no username is configured"
		bashio::exit.nok
	fi
	if ! bashio::config.has_value 'remote_mysql_password';then
		bashio::log.fatal \
		"Remote database has been specified but no password is configured"
		bashio::exit.nok
	fi
	if ! bashio::config.exists 'remote_mysql_port';then
		bashio::log.fatal \
		"Remote database has been specified but no port is configured"
		bashio::exit.nok
	fi
else
	mysqlstate=$(bashio::services "mysql" "host")
	if  bashio::var.is_empty "$mysqlstate";then
	 	bashio::log.fatal \
	 		"Local database access should be provided by the MariaDB addon"
	 	bashio::log.fatal \
	 		"Please ensure it is installed and started"
	 	bashio::exit.nok
	fi
	host=$(bashio::services "mysql" "host")
	password=$(bashio::services "mysql" "password")
	port=$(bashio::services "mysql" "port")
	username=$(bashio::services "mysql" "username")

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

# Create API key if needed
if ! bashio::fs.file_exists "/data/bookstack/appkey.txt"; then
	bashio::log.info "Generating app key"
	key=$(php /var/www/bookstack/artisan key:generate --show)
	echo "${key}" > /data/bookstack/appkey.txt
	bashio::log.info "App Key generated: ${key}"
fi
ln -sf /dev/stderr /var/www/bookstack/storage/logs/laravel.log
