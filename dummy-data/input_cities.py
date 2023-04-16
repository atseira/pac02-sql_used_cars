import psycopg2
import csv

from db_secrets import *

conn = psycopg2.connect(database=DB_NAME, user=DB_USER, password=DB_PASS, host=DB_HOST)


# Open the cities CSV file and insert the data into the cities table
with open('pac_dummy_cities.csv', 'r') as f:
    cur = conn.cursor()
    reader = csv.reader(f)
    next(reader)  # skip the header row
    for row in reader:
        cur.execute(
            "INSERT INTO cities (city_id, city_name, latitude, longitude) VALUES (%s, %s, %s, %s)",
            (row[0], row[1], float(row[2]), float(row[3]))
        )
    conn.commit()

# Close the database connection
cur.close()
conn.close()
