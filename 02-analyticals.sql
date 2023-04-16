-- ANALYTICAL

-- soal 1
SELECT cars.model, COUNT(cars.car_id) as bid_count
FROM bids
LEFT JOIN ads
ON bids.ad_id = ads.ad_id
LEFT JOIN cars
ON ads.car_id = cars.car_id
GROUP BY cars.car_id
ORDER BY bid_count DESC;

-- soal 2
-- Gunakan beberapa view
-- View car_cities didapat dengan join beberapa tabel dari cars -> ads -> users -> cities
CREATE OR REPLACE VIEW car_cities AS
SELECT
	cities.city_name,
	cars.brand,
	cars.model,
	cars.year,
	cars.price_idr
FROM cars
LEFT JOIN ads
ON cars.car_id = ads.car_id
LEFT JOIN users
ON ads.user_id = users.user_id
LEFT JOIN cities
ON users.city_id = cities.city_id;

-- View avg_price_per_city yaitu harga rata-rata semua mobil bekas terdata dalam suatu kota.
CREATE OR REPLACE VIEW avg_price_per_city AS
SELECT cities.city_name, AVG(cars.price_idr) as avg_price
FROM cars
LEFT JOIN ads ON cars.car_id = ads.car_id
LEFT JOIN users ON ads.user_id = users.user_id
LEFT JOIN cities ON users.city_id = cities.city_id
GROUP BY cities.city_name;

-- Join kedua view di atas
SELECT car_cities.*, avg_price_per_city.avg_price as avg_cars_price_in_the_city
FROM car_cities
LEFT JOIN avg_price_per_city
ON car_cities.city_name = avg_price_per_city.city_name
ORDER BY city_name;

-- soal 3
-- Buat view semua bids untuk "Toyota Yaris"
CREATE OR REPLACE VIEW yaris_bids AS
SELECT
	cars.model, bids.user_id, bid_date, bid_price_idr
FROM cars
INNER JOIN ads
ON cars.car_id = ads.car_id
INNER JOIN bids
ON ads.ad_id = bids.ad_id
WHERE cars.model LIKE 'Toyota Yaris';

-- Hitung jumlah berapa kali user bid mobil tersebut sebagai pengecek
CREATE OR REPLACE VIEW user_yaris_bid_count AS
SELECT
	user_id, COUNT(user_id) as bid_count
FROM yaris_bids
GROUP BY model, user_id;
SELECT * FROM user_yaris_bid_count;

-- Tampilkan bidding sekarang dan bidding setelahnya
SELECT
	yaris_bids.model, yaris_bids.user_id, bid_count,
	bid_date, bid_price_idr,
	LEAD(bid_date) OVER (PARTITION BY yaris_bids.user_id ORDER BY bid_date) as next_bid_date,
	LEAD(bid_price_idr) OVER (PARTITION BY yaris_bids.user_id ORDER BY bid_date) as next_bid_price_idr
FROM yaris_bids
LEFT JOIN user_yaris_bid_count
ON yaris_bids.user_id = user_yaris_bid_count.user_id
ORDER BY yaris_bids.user_id ASC, bid_date ASC;

-- soal 4
--  View dari semua bid pada model-model selama 6 bulan terakhir
CREATE OR REPLACE VIEW model_bid_dates_6m AS
SELECT model, bid_price_idr, bid_date
FROM bids
LEFT JOIN ads
ON bids.ad_id = ads.ad_id
LEFT JOIN cars
ON ads.car_id = cars.car_id
WHERE bid_date >= NOW() - INTERVAL '6 months';

-- Hitung average dari harga iklan mobil dan average dari bid 6 bulan terakhir beserta selisih & persentasenya
SELECT
	cars.model,
	AVG(price_idr) AS avg_price,
	AVG(bid_price_idr) AS avg_bid_6month,
	AVG(price_idr) - AVG(bid_price_idr) AS difference,
	(AVG(price_idr)-AVG(bid_price_idr))/AVG(price_idr)*100 AS difference_percent
FROM model_bid_dates_6m
LEFT JOIN cars
ON model_bid_dates_6m.model = cars.model
GROUP BY cars.model;

-- soal 5
-- Subquery untuk menghitung rata-rata bid per bulan.
WITH monthly_avgs AS (
  SELECT
    DATE_TRUNC('month', bid_date) AS month,
    AVG(bid_price_idr) AS avg_bid_price_idr
  FROM yaris_bids
  GROUP BY DATE_TRUNC('month', bid_date)
)

-- Memanfaatkan subquery untuk menentukan periode berapa bulan ke belakang
SELECT
    yb.model,
    yb.bid_price_idr,
    yb.bid_date,
    AVG(yb.bid_price_idr) OVER (
        PARTITION BY DATE_TRUNC('month', yb.bid_date)
        ORDER BY yb.bid_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS avg_current_month,
    COALESCE(ma_prev.avg_bid_price_idr, 0) AS m_min_1,
    COALESCE(ma_prev_2.avg_bid_price_idr, 0) AS m_min_2,
    COALESCE(ma_prev_3.avg_bid_price_idr, 0) AS m_min_3,
    COALESCE(ma_prev_4.avg_bid_price_idr, 0) AS m_min_4,
    COALESCE(ma_prev_5.avg_bid_price_idr, 0) AS m_min_5,
    COALESCE(ma_prev_6.avg_bid_price_idr, 0) AS m_min_6
FROM yaris_bids yb
LEFT JOIN monthly_avgs ma_prev ON DATE_TRUNC('month', yb.bid_date) - INTERVAL '1 month' = ma_prev.month
LEFT JOIN monthly_avgs ma_prev_2 ON DATE_TRUNC('month', yb.bid_date) - INTERVAL '2 month' = ma_prev_2.month
LEFT JOIN monthly_avgs ma_prev_3 ON DATE_TRUNC('month', yb.bid_date) - INTERVAL '3 month' = ma_prev_3.month
LEFT JOIN monthly_avgs ma_prev_4 ON DATE_TRUNC('month', yb.bid_date) - INTERVAL '4 month' = ma_prev_4.month
LEFT JOIN monthly_avgs ma_prev_5 ON DATE_TRUNC('month', yb.bid_date) - INTERVAL '5 month' = ma_prev_5.month
LEFT JOIN monthly_avgs ma_prev_6 ON DATE_TRUNC('month', yb.bid_date) - INTERVAL '6 month' = ma_prev_6.month
GROUP BY
    yb.model, yb.bid_price_idr, yb.bid_date,
    ma_prev.avg_bid_price_idr, 
    ma_prev_2.avg_bid_price_idr,
    ma_prev_3.avg_bid_price_idr,
    ma_prev_4.avg_bid_price_idr,
    ma_prev_5.avg_bid_price_idr,
    ma_prev_6.avg_bid_price_idr
ORDER BY yb.bid_date;


