#!/usr/bin/with-contenv bashio
set -e
MQTT_HOST=$(bashio::services mqtt "host")
MQTT USERNAME=$(bashio::services mqtt "username")
MQTT_PASSWORD=$(bashio::services mqtt "password")
MQTT_SERVER_IP=$(bashio::config 'MQTT_SERVER_IP')
MQTT_SERVER_USERNAME=$(bashio::config 'MQTT_SERVER_USERNAME')
MQTT_SERVER_PASSWORD=$(bashio::config 'MQTT_SERVER_PASSWORD')
MQTT_PORT=$(bashio::config 'MQTT_PORT')
MQTT_TOPIC=$(bashio::config 'MQTT_TOPIC')
MQTT_SERVER_ENABLE=$(bashio::config 'MQTT_SERVER_ENABLE')
IP_INVERTER1=$(bashio::config 'IP_INVERTER1')
INVERTER1_DONGLE_SERIAL=$(bashio::config 'INVERTER1_DONGLE_SERIAL')
IP_INVERTER2=$(bashio::config 'IP_INVERTER2')
INVERTER2_DONGLE_SERIAL=$(bashio::config 'INVERTER2_DONGLE_SERIAL')

echo "Solis MQTT Logger"
echo $MQTT_HOST
bashio::log.info "Inv1 IP "$INVERTER1_DONGLE_SERIAL
/rhi.sh
