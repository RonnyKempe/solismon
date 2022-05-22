#!/usr/bin/env python3
# -*- coding: UTF8 -*-
from pysolarmanv5.pysolarmanv5 import PySolarmanV5
import sys
import paho.mqtt.client as mqtt
from time import sleep
import logging
VALID_DATA1=True
VALID_DATA2=True
Active_Power1=0
Active_Power2=0
Inverter_Temp1=0
Inverter_Temp2=0
PV1_Voltage1=0
PV2_Voltage1=0
PV1_Current1=0
PV2_Current1=0
PV1_Voltage2=0
PV2_Voltage2=0
PV1_Current2=0
PV2_Current2=0
BATTERY_VOLTAGE_BMS=0
BATTERY_CURRENT_BMS=0
BATTERY_POWER=0
TOTAL_DC_OUTPUT_POWER=0
Today_Production1=0
Today_Production2=0
Today_Battery_Charge=0
Today_Battery_discharge=0
Today_Grid_Power_Imported=0
AKKU_SOC=0
AKKU_SOH=0
MQTT_USER="mqtt"
PASSWORD="mqtt"
MQTT_HOST="192.168.0.211"
mqttc = mqtt.Client("Solis")
mqttc.username_pw_set(MQTT_USER, password=PASSWORD)
mqttc.connect(MQTT_HOST, port=1883)
IP1=sys.argv[1]
Ser1=sys.argv[2]
Port1=sys.argv[3]
IP2=sys.argv[4]
Ser2=sys.argv[5]
Port2=sys.argv[6]
print("Args"+IP1+Ser1+Port1+IP2+Ser2+Port2)

def main(IP1, Ser1, Port1, IP2, Ser2, Port2):
	while True:
		try:
			data1(IP1, Ser1, Port1)
		except:
			logging.basicConfig(format='%(asctime)s - %(message)s', datefmt='%d-%b-%y %H:%M:%S')
			logging.warning('Fehler1')
			global VALID_DATA1
			VALID_DATA1=False
		try:
			data2(IP2, Ser2, Port2)
		except:
			logging.basicConfig(format='%(asctime)s - %(message)s', datefmt='%d-%b-%y %H:%M:%S')
			logging.warning('Fehler2')
			global VALID_DATA2
			VALID_DATA2=False

		sleep(5)

def data1(IP, SERIAL, PORT):
	global VALID_DATA1
	
	try:
		logging.basicConfig(format='%(asctime)s - %(message)s', datefmt='%d-%b-%y %H:%M:%S')
		modbus1 = PySolarmanV5(IP, serial=int(SERIAL), port=PORT, mb_slave_id=1, verbose=0)
		Active_Power1=(modbus1.read_input_register_formatted(register_addr=33079, quantity=2, signed=1))
		mqttc.publish("Solis/Power1", Active_Power1);
		#print('Inverter Temp °C')
		Inverter_Temp1=(modbus1.read_input_register_formatted(register_addr=33093, quantity=1, scale=0.1))
		mqttc.publish("Solis/INV1/Temp", Inverter_Temp1);
		#print('PV1 Voltage!')
		PV1_Voltage1=(modbus1.read_input_register_formatted(register_addr=33049, quantity=1, scale=0.1))
		mqttc.publish("Solis/PV1/Voltage1", PV1_Voltage1);
		#print('PV2 Voltage!')
		PV2_Voltage1=(modbus1.read_input_register_formatted(register_addr=33051, quantity=1, scale=0.1))
		mqttc.publish("Solis/PV2/Voltage1", PV2_Voltage1);
		#print('PV1 Current!')
		PV1_Current1=(modbus1.read_input_register_formatted(register_addr=33050, quantity=1, scale=0.1))
		mqttc.publish("Solis/PV1/Current1", PV1_Current1);
		#print('PV2 Current!')
		PV2_Current1=(modbus1.read_input_register_formatted(register_addr=33052, quantity=1, scale=0.1))
		mqttc.publish("Solis/PV2/Current1", PV2_Current1);
		#print('Total DC output Power')
		#DC_OUTPUT_POWER1=(modbus.read_input_register_formatted(register_addr=33126, quantity=2, signed=0))
		#print('Battery Voltage Inv')
		#print(modbus.read_input_register_formatted(register_addr=33133, quantity=1, signed=1, scale=0.1))
		#print('Battery Current Inv')
		#print(modbus.read_input_register_formatted(register_addr=33135, quantity=1, signed=0))
		#print('Battery Voltage BMS')
		BATTERY_VOLTAGE_BMS=(modbus1.read_input_register_formatted(register_addr=33141, quantity=1, signed=0, scale=0.01))
		mqttc.publish("Solis/BMS/Voltage", BATTERY_VOLTAGE_BMS);
		#print('Battery Current BMS')
		BATTERY_CURRENT_BMS=(modbus1.read_input_register_formatted(register_addr=33142, quantity=1, signed=1, scale=0.01))
		mqttc.publish("Solis/BMS/Current", BATTERY_CURRENT_BMS);
		#print('Battery charge current limit')
		#print(modbus.read_input_register_formatted(register_addr=33143, quantity=1, signed=0, scale=0.1))
		#print('Battery discharge current limit')
		#print(modbus.read_input_register_formatted(register_addr=33144, quantity=1, signed=0, scale=0.1))
		#print('Battery power')
		BATTERY_POWER=(modbus1.read_input_register_formatted(register_addr=33149, quantity=2, signed=1))
		mqttc.publish("Solis/Battery/Power", BATTERY_POWER);
		#print('Total Battery charge')
		#print(modbus.read_input_register_formatted(register_addr=33161, quantity=2, signed=0))
		#print('Battery charge today')
		Today_Battery_Charge=(modbus1.read_input_register_formatted(register_addr=33163, quantity=1, signed=0, scale=0.1))
		mqttc.publish("Solis/Battery/Charge/Today", Today_Battery_Charge);
		#print('Battery charge yesterday')
		#print(modbus.read_input_register_formatted(register_addr=33164, quantity=1, signed=0, scale=0.1))
		#print('Total Battery discharge')
		#print(modbus.read_input_register_formatted(register_addr=33165, quantity=2, signed=0))       
		#print("TOTAL_DC output Power")
		TOTAL_DC_OUTPUT_POWER=(modbus1.read_input_register_formatted(register_addr=33057, quantity=2, signed=0))
		mqttc.publish("Solis/DC/Power1", TOTAL_DC_OUTPUT_POWER);
		#print('Akku SOC')
		AKKU_SOC=(modbus1.read_input_register_formatted(register_addr=33139, quantity=1))
		mqttc.publish("Solis/Battery/SOC", AKKU_SOC);     
		#print('Akku SOH')
		AKKU_SOH=(modbus1.read_input_register_formatted(register_addr=33140, quantity=1))
		mqttc.publish("Solis/Battery/SOH", AKKU_SOH);   
		#print('Energie Erzeugung heute')
		Today_Production1=(modbus1.read_input_register_formatted(register_addr=33035, quantity=1, scale=0.1)) 
		mqttc.publish("Solis/Prod1/Today", Today_Production1);
		#print('Energie Erzeugung gestern')
		#print(modbus.read_input_register_formatted(register_addr=33036, quantity=1, scale=0.1))
		Today_Grid_Power_Imported=(modbus1.read_input_register_formatted(register_addr=33171, quantity=1, signed=0, scale=0.1)) 
		mqttc.publish("Solis/Grid/Imported/Today", Today_Grid_Power_Imported);
		VALID_DATA1=True
	finally:
		if VALID_DATA1:
			VALID_DATA1=False
			
def data2(IP, SERIAL, PORT):
	global VALID_DATA2
	try:
		modbus2 = PySolarmanV5(IP, serial=int(SERIAL), port=PORT, mb_slave_id=1, verbose=0)
		#print('PV Power')
		#print(modbus.read_input_register_formatted(register_addr=3007, quantity=1, signed=0))
		#print('AC Power')
		Active_Power2=(modbus2.read_input_register_formatted(register_addr=3005, quantity=1, signed=0))
		mqttc.publish("Solis/Power2", Active_Power2);
		#print('today energy')
		Today_Production2=(modbus2.read_input_register_formatted(register_addr=3014, quantity=1, signed=0, scale=0.1))
		mqttc.publish("Solis/Prod2/Today", Today_Production2);
		#print('yesterday energy')
		#print(modbus.read_input_registers(register_addr=3015, quantity=1))
		#print('dc1 voltage')
		PV1_Voltage2=(modbus2.read_input_register_formatted(register_addr=3021, quantity=1, signed=0, scale=0.1))
		mqttc.publish("Solis/PV1/Voltage2", PV1_Voltage2);
		#print('dc2 voltage')
		PV2_Voltage2=(modbus2.read_input_register_formatted(register_addr=3023, quantity=1, signed=0, scale=0.1))
		mqttc.publish("Solis/PV2/Voltage2", PV2_Voltage2);
		#print('dc1 current')
		PV1_Current2=(modbus2.read_input_register_formatted(register_addr=3022, quantity=1, signed=0, scale=0.1))
		mqttc.publish("Solis/PV1/Current2", PV1_Current2);
		#print('dc2 current')
		PV2_Current2=(modbus2.read_input_register_formatted(register_addr=3024, quantity=1, signed=0, scale=0.1))
		mqttc.publish("Solis/PV2/Current2", PV1_Current2);
		#print('Inverter Temperatur °C')
		Inverter_Temp2=(modbus2.read_input_register_formatted(register_addr=3041, quantity=1, signed=0, scale=0.1))
		mqttc.publish("Solis/INV2/Temp", Inverter_Temp2);
		VALID_DATA2=True
	finally:
		if VALID_DATA2:
			VALID_DATA2=False
			
main(IP1, Ser1, Port1, IP2, Ser2, Port2)
#"192.168.0.128", 4025953112, 8899, "192.168.0.112", 4020737653, 8899
