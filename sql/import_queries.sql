-- load orders data
LOAD DATA LOCAL INFILE 'D:/Nishant/projects/DA/project2/Data/customers.csv'
INTO TABLE customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- load customers data
LOAD DATA LOCAL INFILE 'D:/Nishant/projects/DA/project2/Data/orders.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@order_id, @customer_id, @order_status, @order_purchase_timestamp,
 @order_approved_at, @order_delivered_carrier_date, @order_delivered_customer_date,
 @order_estimated_delivery_date)
SET
order_id = @order_id,
customer_id = @customer_id,
order_status = @order_status,
order_purchase_timestamp = NULLIF(@order_purchase_timestamp,''),
order_approved_at = NULLIF(@order_approved_at,''),
order_delivered_carrier_date = NULLIF(@order_delivered_carrier_date,''),
order_delivered_customer_date = NULLIF(@order_delivered_customer_date,''),
order_estimated_delivery_date = NULLIF(@order_estimated_delivery_date,'');

-- load products data
LOAD DATA LOCAL INFILE 'D:/Nishant/projects/DA/project2/Data/clean_products.csv'
INTO TABLE products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- load sellers data
LOAD DATA LOCAL INFILE 'D:/Nishant/projects/DA/project2/Data/sellers.csv'
INTO TABLE sellers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- load order_items data
LOAD DATA LOCAL INFILE 'D:/Nishant/projects/DA/project2/Data/order_items.csv'
INTO TABLE order_items
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- load order_payments data
LOAD DATA LOCAL INFILE 'D:/Nishant/projects/DA/project2/Data/order_payments.csv'
INTO TABLE order_payments
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- load order_reviews data
-- CREATE TABLE order_reviews_staging (
--     review_id TEXT,
--     order_id TEXT,
--     review_score TEXT,
--     review_comment_title TEXT,
--     review_comment_message TEXT,
--     review_creation_date TEXT,
--     review_answer_timestamp TEXT
-- );

-- load order_payments_agg data
LOAD DATA LOCAL INFILE 'D:/Nishant/projects/DA/project2/Data/clean_payments.csv'
INTO TABLE order_payments_agg
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'D:/Nishant/projects/DA/project2/Data/order_reviews_clean.csv'
INTO TABLE order_reviews_staging
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n';
-- IGNORE 1 LINES;

INSERT INTO order_reviews (
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message,
    review_creation_date,
    review_answer_timestamp
)
SELECT
    review_id,
    order_id,
    CAST(review_score AS UNSIGNED),
    review_comment_title,
    review_comment_message,
    STR_TO_DATE(review_creation_date, '%Y-%m-%d %H:%i:%s'),
    STR_TO_DATE(review_answer_timestamp, '%Y-%m-%d %H:%i:%s')
FROM order_reviews_staging;

-- load geolocation data
LOAD DATA LOCAL INFILE 'D:/Nishant/projects/DA/project2/Data/clean_geolocation.csv'
INTO TABLE geolocation
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- load product category name data
LOAD DATA LOCAL INFILE 'D:/Nishant/projects/DA/project2/Data/product_category_name_translation.csv'
INTO TABLE product_category_name_translation
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
