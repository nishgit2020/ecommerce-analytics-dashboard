-- create database
create database ecommerce;
use ecommerce;

-- create tables
-- 1 create orders table
create table orders(
	order_id varchar(50) not null PRIMARY KEY,
    customer_id varchar(50) not null,
    order_status varchar(30) not null,
    order_purchase_timestamp datetime not null,	
    order_approved_at datetime null,
    order_delivered_carrier_date datetime null,
    order_delivered_customer_date datetime null,	
    order_estimated_delivery_date datetime null
);

-- 2 create customers table
create table customers(
customer_id	varchar(50) not null PRIMARY KEY,
customer_unique_id varchar(50) not null,
customer_zip_code_prefix int not null,
customer_city varchar(50) not null,
customer_state varchar(10) not null
);

-- 3 create sellers table
create table sellers(
seller_id  varchar(50) not null PRIMARY KEY,
seller_zip_code_prefix int not null,
seller_city varchar(100) not null,
seller_state varchar(20) not null
);

-- 4 create products table
create table products(
product_id varchar(50) primary Key,
product_category_name varchar(100) null,
product_name_lenght int null,
product_description_lenght int null,
product_photos_qty int null,
product_weight_g DECIMAL(10,2) not null,
product_length_cm DECIMAL(10,2) not null,
product_height_cm DECIMAL(10,2) not null,
product_width_cm DECIMAL(10,2) not null
);

-- 5 create geolocation table
create table geolocation(
geolocation_zip_code_prefix int not null PRIMARY KEY,
geolocation_lat float not null,
geolocation_lng float not null,
geolocation_city varchar(50) not null,
geolocation_state varchar(20) not null
);

-- 6 create order_payments table
create table order_payments(
order_id  varchar(50) not null,
payment_sequential int not null ,
payment_type varchar(50) not null,
payment_installments int not null,
payment_value DECIMAL(10,2) not null,
PRIMARY KEY(order_id,payment_sequential)
);

-- 7 create order_items table
create table order_items(
order_id  varchar(50) not null,
order_item_id int not null,
product_id varchar(50) not null,
seller_id varchar(50) not null,
shipping_limit_date datetime not null,
price DECIMAL(10,2) not null,
freight_value DECIMAL(10,2) not null,
PRIMARY KEY(order_id,order_item_id)
);

-- 8 create order_reviews table
create table order_reviews(
review_id varchar(50) not null,
order_id varchar(50) not null,
review_score int not null,
review_comment_title varchar(200) null,
review_comment_message varchar(200) null,
review_creation_date datetime not null,
review_answer_timestamp datetime not null,
PRIMARY KEY(review_id,order_id)
);

-- 9 create product_category_name_translation table
create table product_category_name_translation(
product_category_name  varchar(200) not null PRIMARY KEY,
product_category_name_english varchar(200) not null
);

-- temproary table - order_reviews_staging
CREATE TABLE order_reviews_staging (
    review_id TEXT,
    order_id TEXT,
    review_score TEXT,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date TEXT,
    review_answer_timestamp TEXT
);

-- create aggregated order_payments table
create table order_payments_agg(
order_id  varchar(50) not null,
total_payments DECIMAL(10,2) not null,
PRIMARY KEY(order_id)
);

-- add foreign key
alter table orders 
add constraint fk_orders_customers
foreign key (customer_id)
references customers(customer_id); 

alter table order_items
add constraint fk_order_items_orders
foreign key (order_id)
references orders(order_id);

alter table order_payments
add constraint fk_order_payments_orders
foreign key (order_id)
references orders(order_id);

alter table order_items
add constraint fk_order_items_products
foreign key (product_id)
references products(product_id);

alter table order_items
add constraint fk_order_items_sellers
foreign key (seller_id)
references sellers(seller_id);






