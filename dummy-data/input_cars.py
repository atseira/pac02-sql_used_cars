import psycopg2
import csv


from db_secrets import *

conn = psycopg2.connect(database=DB_NAME, user=DB_USER, password=DB_PASS, host=DB_HOST)

# Open the cars CSV file and insert the data into the cars table
with open('pac_dummy_cars.csv', 'r') as f:
    cur = conn.cursor()
    reader = csv.reader(f)
    next(reader)  # skip the header row
    for row in reader:
        cur.execute(
            "INSERT INTO cars (car_id, brand, model, body_type, year, price_idr) VALUES (%s, %s, %s, %s, %s, %s)",
            (int(row[0]), row[1], row[2], row[3], int(row[4]), int(row[5]))
        )
    conn.commit()

# Close the database connection
cur.close()
conn.close()
