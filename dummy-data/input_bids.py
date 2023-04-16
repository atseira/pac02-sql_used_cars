import psycopg2
import csv
from datetime import date

# Connect to the PostgreSQL database
conn = psycopg2.connect(
    host="localhost",
    database="your_database",
    user="your_username",
    password="your_password"
)

# Open the bids CSV file and insert the data into the bids table
with open('bids.csv', 'r') as f, open('bids_output.csv', 'w', newline='') as out:
    cur = conn.cursor()
    reader = csv.reader(f)
    writer = csv.writer(out)
    next(reader)  # skip the header row
    writer.writerow(['user_id', 'ad_id', 'bid_price_idr', 'bid_date', 'bid_id'])  # write the header row
    for row in reader:
        cur.execute(
            "INSERT INTO bids (user_id, ad_id, bid_price_idr, bid_date) VALUES (%s, %s, %s, %s) RETURNING bid_id",
            (int(row[0]), int(row[1]), int(row[2]), date.today())
        )
        bid_id = cur.fetchone()[0]
        writer.writerow(row + [date.today(), bid_id])
    conn.commit()

# Close the database connection
cur.close()
conn.close()
