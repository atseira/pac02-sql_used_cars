import psycopg2
import csv
from datetime import datetime

from db_secrets import *

conn = psycopg2.connect(database=DB_NAME, user=DB_USER, password=DB_PASS, host=DB_HOST)


# Open the ads CSV file and insert the data into the ads table

with open('dummy_ads.csv', 'r') as f:
    cur = conn.cursor()
    reader = csv.reader(f)
    next(reader)  # skip the header row
    for row in reader:
        negotiable = False if row[7].lower() == "false" else True
        cur.execute(
            "INSERT INTO ads (user_id, car_id, title, description, mileage_km, transmission, color, negotiable, post_date) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)",
            (int(row[0]), int(row[1]), row[2], row[3], int(row[4]), row[5], row[6], negotiable, datetime.strptime(row[8], "%Y-%m-%d").date())
        )
    conn.commit()

# Close the database connection
cur.close()
conn.close()
