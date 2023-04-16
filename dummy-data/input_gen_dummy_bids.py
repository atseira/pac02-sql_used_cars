import random
from datetime import datetime, timedelta

import psycopg2
from psycopg2 import Error

from db_secrets import *

def get_conn():
    return psycopg2.connect(database=DB_NAME, user=DB_USER, password=DB_PASS, host=DB_HOST)

# get user_ids list from database
def get_all_user_ids():
    conn = get_conn()
    cur = conn.cursor()
    cur.execute("SELECT user_id FROM users")
    rows = cur.fetchall()
    user_ids = [row[0] for row in rows] # extract the user_id column from the result set
    cur.close()
    conn.close()
    return user_ids

# get negotiable ad_ids list 
def get_negotiable_ads():
    conn = get_conn()
    cur = conn.cursor()
    cur.execute('''
        SELECT ad_id, post_date, cars.price_idr
        FROM ads
        LEFT JOIN cars
        ON ads.car_id = cars.car_id
        WHERE negotiable = true
    ''')
    rows = cur.fetchall()
    ads = [{'ad_id': row[0], 'post_date': row[1], 'price_idr': row[2]} for row in rows] # create a list of dictionaries
    cur.close()
    conn.close()
    return ads


ad_ids_cache = {}

def get_ad_ids_by_user(user_id):
    if user_id in ad_ids_cache:
        return ad_ids_cache[user_id]
    
    conn = get_conn()
    cur = conn.cursor()
    cur.execute("SELECT ad_id FROM ads WHERE user_id = %s", (user_id,))
    rows = cur.fetchall()
    ad_ids = [row[0] for row in rows] # extract the ad_id column from the result set
    cur.close()
    conn.close()
    
    ad_ids_cache[user_id] = ad_ids  # add to cache
    
    return ad_ids


def generate_random_bid(post_date_obj, min_price_idr, max_price_idr, max_days_after_post):
    # generate a random bid price lower than the original price_idr
    min_price_idr = 1_000_000 if min_price_idr < 1_000_000 else min_price_idr
    max_price_idr = min_price_idr if max_price_idr < min_price_idr else max_price_idr

    bid_price = random.randint(min_price_idr//1_000_000, max_price_idr//1_000_000) * 1_000_000

    # generate a random bid date later than the post_date
    days_after_post = random.randint(1, max_days_after_post)
    bid_date_obj = post_date_obj + timedelta(days=days_after_post) # add days_after_post to post_date

    return bid_price, bid_date_obj

def get_latest_bid_by_user(user_id, ad_id):
    conn = get_conn()
    cur = conn.cursor()
    cur.execute("SELECT bid_price_idr, bid_date FROM bids WHERE user_id = %s AND ad_id = %s ORDER BY bid_date DESC LIMIT 1", (user_id, ad_id))
    row = cur.fetchone()
    cur.close()
    conn.close()
    if row:
        return {'bid_price': row[0], 'bid_date': row[1]}
    else:
        return None
    
def insert_bid(user_id, ad_id, bid_price_idr, bid_date):
    try:
        # Establish a connection to the database
        conn = get_conn()

        # Create a cursor object
        cursor = conn.cursor()

        # Define the PostgreSQL insert statement
        insert_query = """INSERT INTO bids (user_id, ad_id, bid_price_idr, bid_date)
                          VALUES (%s, %s, %s, %s)"""

        # Execute the insert statement
        cursor.execute(insert_query, (user_id, ad_id, bid_price_idr, bid_date))

        # Commit the transaction
        conn.commit()

    except (Exception, Error) as error:
        print("Error while connecting to PostgreSQL", error)

    finally:
        # Close the database connection
        if conn:
            cursor.close()
            conn.close()


user_ids = get_all_user_ids()
ad_ids = get_negotiable_ads()

random_ad = 0
random_user = 0
bid_price = 0
bid_date = ''

data_count = 500
for i in range(data_count):
    # randomly select a negotiable ad_id
    random_ad = random.choice(ad_ids)
    # randomly select a user_id from user_ids, as a bidder
    random_user = 0
    while True:
        random_user = random.choice(user_ids)

        # check if the negotiable ad_id has user_id that is equal to the bidder's user_id
        user_ads = get_ad_ids_by_user(random_user)
        if random_ad not in user_ads:
            break
    
    latest_bid = get_latest_bid_by_user(random_user, random_ad["ad_id"])
    if latest_bid == None:
        bid_price, bid_date = generate_random_bid(random_ad["post_date"],
                                                1_000_000, random_ad["price_idr"],
                                                30)
    else:
        bid_price, bid_date = generate_random_bid(latest_bid["bid_date"],
                                                latest_bid["bid_price"], random_ad["price_idr"],
                                                30)
    insert_bid(random_user, random_ad["ad_id"], bid_price, bid_date)
    print(f"Processed row {i+1} of {data_count}")

