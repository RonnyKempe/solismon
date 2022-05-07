#!/usr/bin/with-contenv bashio
echo $(bashio::services mqtt "host")
echo $(bashio::services mqtt "username")
MQTT_PASSWORD=$(bashio::services mqtt "password")
echo "Hello world!"

python3 -m http.server 8000
