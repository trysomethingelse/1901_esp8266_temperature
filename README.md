# ESP8266_temperature
ESP8266 works as MQTT client and sends temperature to MQTT Broker. Paho client in python reads new data and saves in sql database. HTTP server with Dash reads new data when site is refreshed and shows it on graph.

## How to start?
(tested on Windows 10)
1. Flash new firmware to yours ESP (working firmware is at firmware location on GitHub)
2. Upload all files from LUA folder to your ESP and create additional file ("credentials.lua") with your wifi network infromation as given below:

`SSID = "ssid_of_your_network"`

`PASSWORD = "password_of_your_network"`
 
3. Run mosquitto broker

4. Run python script `main.py` . Script will create database file at location and name given inside script. Then received data from esp will go to database. Http server should be available at default address http://127.0.0.1:8050/

:exclamation: At first run of ESP network should be available because of time synchronization. If not esp will stuck. After first synchronization data will be saved in memory if network will be not accessible and in new connection all of it will be transmitted.


## How to change time interval of deep sleep with MQTT?

Publish to path: esp/set where message is time interval in seconds, max is about 71 min.

For example:

`mosquitto_pub -t esp/set -m 60 -h 192.168.137.1`

## Electronic schematic:
![Kicad schematic](/images/schematic.png)

## Data presentation:
![data on http server](/images/data.PNG)
