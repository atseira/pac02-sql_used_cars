import csv
import random
from faker import Faker

# Set locale to Indonesian
fake = Faker('id_ID')

# Generate a random Indonesian-like phone number
def generate_phone_number():
    return fake.phone_number()

# Generate a random Indonesian name
def generate_name():
    name = fake.first_name()
    surname = fake.last_name()
    return f"{name} {surname}"

# Choose a random city
def random_city_id():
    city_ids = [
        3171,
        3172,
        3173,
        3174,
        3175,
        3573,
        3578,
        3471,
        3273,
        1371,
        1375,
        6471,
        6472,
        7371,
        5171,
    ] # dummy IDs from Pacmann's dummy city table 
    return random.choice(city_ids)


# Generate dummy user data and write to CSV file
with open("dummy_users.csv", mode="w", newline="") as file:
    writer = csv.writer(file)
    writer.writerow(["User ID", "Name", "Phone", "City ID"])

    for i in range(100):  # generate 100 rows
        name = generate_name()
        phone = generate_phone_number()
        city_id = random_city_id()
        writer.writerow([i+1,name, phone, city_id])
