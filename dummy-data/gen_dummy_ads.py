import random
import csv
from datetime import datetime, timedelta

car_data = {}
# read the car data from the CSV file and store it in a dictionary
with open("pac_dummy_cars.csv", mode="r") as csv_file:
    reader = csv.DictReader(csv_file)
    i = 1
    for row in reader:
        car_data[i] = {
            "brand": row["brand"],
            "model": row["model"],
            "body_type": row["body_type"],
            "year": row["year"],
            "price": row["price"]
        }
        i += 1


def generate_car_ad_title_and_description(car_model, transmission_type, year, mileage, color, negotiable):
    # List of possible short descriptors to include in the title
    descriptors = ["mulus", "gres", "kinclong", "bebas banjir", "bebas tabrak", "kayak baru", "terawat", "BU"]

    # Randomly select a subset of descriptors to include in the title
    num_descriptors = random.randint(1, 3)
    title_descriptors = random.sample(descriptors, num_descriptors)

    # Combine the descriptors and arguments to create the title
    title_parts = [year, transmission_type, color]
    random.shuffle(title_parts)
    title = " ".join([car_model] + title_parts + title_descriptors)

    # Create the description by combining the arguments and additional descriptors
    description_parts = ["Dijual mobil bekas", car_model, "tahun", str(year), "transmisi", transmission_type, "jarak tempuh", str(mileage), "km", "warna", color] + title_descriptors
    if negotiable:
        description_parts.append("bisa nego")
    description = " ".join(description_parts)

    # Return the title and description as a tuple
    return (title, description)

def generate_car_color():
    car_colors = ["Putih", "Hitam", "Abu-abu", "Merah", "Biru", "Hijau", "Silver", "Kuning", "Coklat", "Ungu"]
    return random.choice(car_colors)

def generate_mileage():
    mileage = random.randint(10, 200) * 1000
    return mileage

def generate_random_date(start_date, end_date):
    # Convert input strings to datetime objects
    start_datetime = datetime.strptime(start_date, '%Y-%m-%d')
    end_datetime = datetime.strptime(end_date, '%Y-%m-%d')

    # Calculate the time difference between start and end dates
    delta = end_datetime - start_datetime

    # Generate a random number of days within the date range
    random_days = random.randrange(delta.days + 1)

    # Calculate the random date
    random_date = start_datetime + timedelta(days=random_days)

    # Return the random date as a string in 'YYYY-MM-DD' format
    return random_date.strftime('%Y-%m-%d')

# create a list to store the generated data
car_ads = []

# generate 50 rows of data
for i in range(1, 51):
    # generate user_id between 1 to 100
    user_id = random.randint(1, 100)
    # generate unique car_id between 1 to 50
    car_id = i
    # generate mileage
    mileage = generate_mileage()
    # generate car color
    color = generate_car_color()
    # generate negotiable (True or False)
    negotiable = random.choice([True, False])
    # generate car ad title and description
    car_model = car_data[i]["model"]
    transmission_type = random.choice(["manual", "otomatis"])
    year = car_data[i]["year"]
    post_date = generate_random_date('2022-10-01', '2023-03-31')

    title, description = generate_car_ad_title_and_description(car_model, transmission_type, year, mileage, color, negotiable)
    
    # append the data to the list
    car_ads.append({
        "user_id": user_id,
        "car_id": car_id,
        "title": title,
        "description": description,
        "mileage": mileage,
        "transmission": transmission_type,
        "color": color,
        "negotiable": negotiable,
        "post_date": post_date,
    })

# save the generated data to a CSV file
with open("dummy_ads.csv", mode="w", newline="") as csv_file:
    fieldnames = ["user_id", "car_id", "title", "description", "mileage", "transmission", "color", "negotiable", "post_date"]
    writer = csv.DictWriter(csv_file, fieldnames=fieldnames)

    writer.writeheader()
    for car_ad in car_ads:
        writer.writerow(car_ad)
