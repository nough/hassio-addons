#!/usr/bin/with-contenv bashio
# shellcheck shell=bash

if bashio::config.true 'ssl'; then

    # Validate ssl
    bashio::config.require.ssl

    # Adapt nginx template
    certfile=$(bashio::config 'certfile')
    keyfile=$(bashio::config 'keyfile')
    sed -i "s|%%certfile%%|${certfile}|g" /etc/nginx/servers/ssl.conf
    sed -i "s|%%keyfile%%|${keyfile}|g" /etc/nginx/servers/ssl.conf
    sed -i "s|3000;|3000 ssl;|g" /etc/nginx/servers/ssl.conf

else

    sed -i "/ssl/d" /etc/nginx/servers/ssl.conf

fi
