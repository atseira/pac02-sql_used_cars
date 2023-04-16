import psycopg2
import csv

from db_secrets import *

conn = psycopg2.connect(database=DB_NAME, user=DB_USER, password=DB_PASS, host=DB_HOST)

# Open the users CSV file and insert the data into the users table
with open('dummy_users.csv', 'r') as f:
    cur = conn.cursor()
    reader = csv.reader(f)
    next(reader)  # skip the header row
    for row in reader:
        cur.execute(
            "INSERT INTO users (user_id, name, phone_number, city_id) VALUES (%s, %s, %s, %s)",
            (int(row[0]), row[1], row[2], int(row[3]))
        )
    conn.commit()

# Close the database connection
cur.close()
conn.close()
