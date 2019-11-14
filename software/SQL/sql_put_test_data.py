from SQL.sql_operations import Operations
import random
import time

DATABASE_PATH = "C:\\Users\\Mateusz Gutowski\\Desktop\\esp12\\files\\databases\\"
DATABASE_FILE = "esp_test.db"

NUMBER_OF_ROWS = 100


def str_time_prop(start, end, time_format, prop):
    stime = time.mktime(time.strptime(start, time_format))
    etime = time.mktime(time.strptime(end, time_format))

    ptime = stime + prop * (etime - stime)

    return time.strftime(time_format, time.localtime(ptime))


def random_date(start, end, time_format, prop):
    return str_time_prop(start, end, time_format, prop)


if __name__ == "__main__":
    db_insert = Operations(DATABASE_PATH, DATABASE_FILE)
    random.seed()

    start_time = "2019-06-18 21:30:11"
    end_time = "2019-06-19 21:30:11"

    my_time_format = "%Y-%m-%d %H:%M:%S"
    for row in range(NUMBER_OF_ROWS):
        temperature = random.randrange(0, 2000) / 20
        date_time = random_date(start_time, end_time, my_time_format, row / NUMBER_OF_ROWS)
        data = (temperature, date_time)
        print(data)

        db_insert.create_new_insert(data)
