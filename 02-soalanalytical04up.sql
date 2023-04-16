select model, AVG(price_idr) from cars group by model;

CREATE VIEW model_bid_dates_6m AS
SELECT model, bid_price_idr, bid_date
FROM bids
LEFT JOIN ads
ON bids.ad_id = ads.ad_id
LEFT JOIN cars
ON ads.car_id = cars.car_id
WHERE bid_date >= NOW() - INTERVAL '6 months';

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

