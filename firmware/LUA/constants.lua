file_name_deep_sleep = "deep_sleep_time.txt"
file_name_data = "data.txt"
client_id = "esp"
ip_address = "192.168.137.1"
port = 1883

publish_path = "esp/data"
subscribe_path = "esp/set"
lw_path = "esp/lwt"

main_timer_interval = 1000
data_timer_interval = 20
dsleep_timer_interval = 2000 --timer if module can go to sleep

delimiter = "&"
ds18b20_pin = 5--gpio14

-- total_tries: how many times the station will attempt to connect to the AP. Should consider AP reboot duration.
total_tries = 15
no_ap_tries = 4
