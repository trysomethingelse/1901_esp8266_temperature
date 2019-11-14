import sqlite3
from sqlite3 import Error


class Operations:

    def __init__(self, database_path, database_file):
        try:
            self.conn = sqlite3.connect(database_path + database_file)
        except Error as e:
            print(e)
        self.create_table()

    def create_table(self):
        sql_create_temperature_table = """CREATE TABLE IF NOT EXISTS temperature (
                                                id integer PRIMARY KEY,
                                                value float,
                                                date_time DATETIME );"""
        try:
            c = self.conn.cursor()
            c.execute(sql_create_temperature_table)
        except Error as e:
            print(e)

    def create_new_insert(self, data):
        """
        :param data: Is tuple (temperature,date_time)
        :return: number of last row in database
        """
        sql = "INSERT INTO temperature(value, date_time) VALUES (?,?)"
        with self.conn:
            cur = self.conn.cursor()
            cur.execute(sql, data)
        return cur.lastrowid

    def load_data(self, column):
        """
        :param column: is str with names of columns in table which will be returned
        :return: data from database
        """
        sql = "SELECT {col} FROM temperature".format(col=column)
        with self.conn:
            cur = self.conn.cursor()
            cur.execute(sql)
        return cur.fetchall()
