import threading
from mqtt_listen import MQTT
from HTTP.http_server import HTTP

DATABASE_PATH = "C:\\Users\\Mateusz Gutowski\\Desktop\\esp12\\files\\databases\\"
DATABASE_FILE = "esp_temperature.db"


def mqtt_start():
    mqtt = MQTT(DATABASE_PATH, DATABASE_FILE)


def http_start():
    http = HTTP(DATABASE_PATH, DATABASE_FILE)
    http.start()


if __name__ == "__main__":
    threading.Thread(target=mqtt_start).start()
    threading.Thread(target=http_start).start()
