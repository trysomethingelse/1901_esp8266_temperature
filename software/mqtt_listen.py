import paho.mqtt.subscribe as subscribe
from SQL.sql_operations import Operations
from dateutil.parser import parse

hostname = "192.168.137.1"
port = 1883


class MQTT:
    topic = "esp/data"

    def __init__(self, database_path, database_file):
        self.db_insert = Operations(database_path, database_file)
        subscribe.callback(self.on_message, self.topic, hostname=hostname, port=port, qos=1)

    def on_message(self, client, userdata, msg):
        print("-------------")
        print("%s %s" % (msg.topic, msg.payload))
        data = msg.payload.decode().split("&")

        print("splited:", data)
        if self.is_data_good(data):
            self.db_insert.create_new_insert((data[0], data[1]))
        else:
            print("data is not valid")

    def get_single_msg(self, topic):
        msg = subscribe.simple(topic, hostname=hostname,
                               port=port, client_id="", keepalive=60)
        return msg

    def is_data_good(self, data):
        temp = data[0]  # temperature
        dt = data[1]  # data_time

        try:
            t = float(temp)
        except:
            print("temperature is not float")
            return False

        # if temperature excess range of sensor
        if t < -55 or t > 125:
            return False

        # check if date is valid
        try:
            parse(dt, fuzzy=False)
        except ValueError:
            return False
        return True
