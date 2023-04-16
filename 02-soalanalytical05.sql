WITH monthly_avgs AS (
  SELECT
    DATE_TRUNC('month', bid_date) AS month,
    AVG(bid_price_idr) AS avg_bid_price_idr
  FROM yaris_bids
  GROUP BY DATE_TRUNC('month', bid_date)
)
SELECT
  yb.model,
  yb.bid_price_idr,
  yb.bid_date,
  AVG(yb.bid_price_idr) OVER (
    PARTITION BY DATE_TRUNC('month', yb.bid_date) ORDER BY yb.bid_date
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


