-- TRANSACTIONAL 

-- soal 1
SELECT *
FROM cars
WHERE year >= 2015;

-- soal 2
SELECT c.car_id, b.user_id, bid_date, bid_price_idr
FROM bids b
LEFT JOIN ads a 
ON b.ad_id = a.ad_id
LEFT JOIN cars c
ON a.car_id = c.car_id
WHERE a.ad_id = 16;

INSERT INTO bids
	(user_id, ad_id, bid_price_idr, bid_date)
VALUES
	(50, 16, 70000000, '2023-02-15');

-- soal 3
-- random pilih user yang punya iklan
SELECT users.user_id, users.name
FROM ads
LEFT JOIN users
ON ads.user_id = users.user_id
ORDER BY random()
LIMIT 1;

SELECT cars.car_id, brand, model, year, cars.price_idr, ads.post_date
FROM cars
LEFT JOIN ads
ON cars.car_id = ads.ad_id
WHERE ads.user_id = 46
ORDER BY ads.post_date DESC;

-- soal 4
SELECT car_id, brand, model, year, price_idr
FROM cars
WHERE model LIKE '%Yaris'
ORDER BY price_idr ASC;

-- soal 5 cari mobil terdekat
CREATE OR REPLACE FUNCTION haversine_distance(lat1 FLOAT, lon1 FLOAT, lat2 FLOAT, lon2 FLOAT)
RETURNS DOUBLE PRECISION AS $$
DECLARE
	lat1 float := radians(lat1);
	lon1 float := radians(lon1);
	lat2 float := radians(lat2);
	lon2 float := radians(lon2);

	dlon float := lon2 - lon1;
	dlat float := lat2 - lat1;
	a float;
	b float;
	c float;
	r float := 6371;
	jarak float;
BEGIN
	-- haversine formula
	a := sin(dlat/2)^2 + cos(lat1) * cos(lat2) * sin(dlon/2)^2;
	c := 2 * asin(sqrt(a));
	jarak := r * c;
RETURN
	jarak;
END;
$$ LANGUAGE plpgsql;

SELECT cars.*,
	haversine_distance(
		(SELECT latitude FROM cities WHERE city_id = 3173),
		(SELECT longitude FROM cities WHERE city_id = 3173),
		cities.latitude,
		cities.longitude
	) AS distance,
	cities.city_name
FROM cars
LEFT JOIN ads
ON cars.car_id = ads.ad_id
LEFT JOIN users
ON ads.user_id = users.user_id
LEFT JOIN cities
ON users.city_id = cities.city_id
ORDER BY distance;