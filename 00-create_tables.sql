CREATE TABLE cities (
  city_id SERIAL PRIMARY KEY,
  city_name TEXT NOT NULL,
  latitude NUMERIC(8, 6) NOT NULL,
  longitude NUMERIC(9, 6) NOT NULL,
  UNIQUE(latitude, longitude)
);

CREATE TABLE users (
  user_id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  phone_number TEXT UNIQUE NOT NULL,
  city_id INTEGER NOT NULL REFERENCES cities(city_id)
);

CREATE TABLE cars (
  car_id SERIAL PRIMARY KEY,
  brand TEXT NOT NULL,
  model TEXT NOT NULL,
  body_type TEXT NOT NULL,
  price_idr INTEGER NOT NULL,
  year INTEGER NOT NULL
);

CREATE TABLE ads (
  ad_id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(user_id),
  car_id INTEGER NOT NULL REFERENCES cars(car_id),
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  mileage_km INTEGER NOT NULL,
  color TEXT NOT NULL,
  transmission TEXT NOT NULL,
  negotiable BOOLEAN NOT NULL,
  post_date DATE NOT NULL
);

CREATE TABLE bids (
  bid_id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(user_id),
  ad_id INTEGER NOT NULL REFERENCES ads(ad_id),
  bid_price_idr INTEGER NOT NULL,
  bid_date DATE NOT NULL
);
