/*

Level 2

*/

CREATE SCHEMA books_schema;

CREATE TABLE books_schema.books1 
(
	isbn varchar(15) PRIMARY KEY,
	book_title varchar(300),
	book_author varchar(300),
	year_of_publication integer,
	publisher varchar(300)
);

COPY books_schema.books1 (isbn, book_title, book_author, year_of_publication, publisher)
FROM '/tmp/books1.csv'
DELIMITER ','
CSV HEADER;

select count(*) from books_schema.books1;

CREATE TABLE books_schema.books2 
(
	isbn varchar(15) PRIMARY KEY,
	book_title varchar(300),
	book_author varchar(300),
	year_of_publication integer,
	publisher varchar(300)
);

COPY books_schema.books2 (isbn, book_title, book_author, year_of_publication, publisher)
FROM '/tmp/books2.csv'
DELIMITER ','
CSV HEADER;


select count(*) from books_schema.books2;


CREATE TABLE books_schema.users 
(
	user_id integer PRIMARY KEY,
	age INT,
	city VARCHAR(100),
	state VARCHAR(100),
	country VARCHAR(100),
	gender VARCHAR(1)
);

COPY books_schema.users (user_id, age, city, state, country, gender)
FROM '/tmp/users.csv'
DELIMITER ','
CSV HEADER;

select count(*) from books_schema.users;

CREATE TABLE books_schema.ratings 
(
	rating_id INT PRIMARY KEY,
	user_id INT,
	isbn VARCHAR(15),
	book_rating SMALLINT
);

COPY books_schema.ratings (rating_id, user_id, isbn, book_rating)
FROM '/tmp/ratings.csv'
DELIMITER ','
CSV HEADER;

select count(*) from books_schema.ratings;


CREATE SCHEMA ecommerce_schema;

CREATE TABLE ecommerce_schema.customers
(	
    customer_id varchar(32) PRIMARY KEY,
    customer_name varchar(20),
    customer_zip_code_prefix integer,
    customer_city varchar(50),
    customer_state varchar(20)
);


COPY ecommerce_schema.customers (customer_id, customer_name, customer_zip_code_prefix,customer_city, customer_state)
FROM '/tmp/customers.csv'
DELIMITER ','
CSV HEADER;


CREATE TABLE ecommerce_schema.products
(	
    product_id varchar(32) PRIMARY KEY,
    product_category_name varchar(50),
    product_price integer,
    product_weight_g integer,
    product_length_cm integer,
    product_height_cm integer,
    product_width_cm integer
);


COPY ecommerce_schema.products (product_id, product_category_name, product_price, product_weight_g, product_length_cm, product_height_cm, product_width_cm)
FROM '/tmp/products.csv'
DELIMITER ','
CSV HEADER;


CREATE TABLE ecommerce_schema.suppliers
(	
    supplier_id varchar(32) PRIMARY KEY, 
    supplier_zip_code_prefix integer, 
    supplier_city varchar(50), 
    supplier_state varchar(2)
);


COPY ecommerce_schema.suppliers (supplier_id, supplier_zip_code_prefix, supplier_city, supplier_state)
FROM '/tmp/suppliers.csv'
DELIMITER ','
CSV HEADER;


CREATE TABLE ecommerce_schema.orders
(	
    order_id varchar(32) PRIMARY KEY,
    customer_id varchar(32) REFERENCES ecommerce_schema.customers(customer_id),
    order_status varchar(20),
    order_purchase_timestamp timestamp,
    order_delivered_customer_date timestamp,
    order_estimated_delivery_date timestamp
);

SET datestyle = 'European, DMY';

COPY ecommerce_schema.orders (order_id, customer_id, order_status, order_purchase_timestamp, 
                              order_delivered_customer_date, order_estimated_delivery_date)
FROM '/tmp/orders.csv'
DELIMITER ','
CSV HEADER;


CREATE TABLE ecommerce_schema.order_reviews
(	
    review_id integer PRIMARY KEY,
    order_id varchar(32) REFERENCES ecommerce_schema.orders(order_id),
    review_score smallint,
    review_creation_date timestamp
);


COPY ecommerce_schema.order_reviews (review_id, order_id, review_score, review_creation_date)
FROM '/tmp/order_reviews.csv'
DELIMITER ','
CSV HEADER;

CREATE TABLE ecommerce_schema.order_items
(	
    order_id varchar(32),  	    
    order_item_id integer,    
    product_id varchar(32) REFERENCES ecommerce_schema.products(product_id),
    shipping_limit_date timestamp, 
    price float,
    freight_value float,
    PRIMARY KEY (order_id, order_item_id)
);


COPY ecommerce_schema.order_items (order_id, order_item_id, product_id,
                                  shipping_limit_date, price, freight_value)                                
FROM '/tmp/order_items.csv'
DELIMITER ','
CSV HEADER;


CREATE TABLE ecommerce_schema.order_payments
(	
    order_id varchar(32),
    payment_sequential smallint,
    payment_type varchar(20),
    payment_installments smallint, 
    payment_value float,
    PRIMARY KEY (order_id, payment_sequential)
);


COPY ecommerce_schema.order_payments (order_id, payment_sequential, payment_type, payment_installments, payment_value)
FROM '/tmp/order_payments.csv'
DELIMITER ','
CSV HEADER;


/*
	UNION
*/

select * from ecommerce_schema.customers limit 10;

SELECT customer_state, count(distinct customer_city) as amount_cities
FROM ecommerce_schema.customers
GROUP BY customer_state
ORDER BY 2;


SELECT distinct customer_city
FROM ecommerce_schema.customers
WHERE customer_state = 'CE';

SELECT distinct supplier_city
FROM ecommerce_schema.suppliers
WHERE supplier_state = 'CE';


SELECT distinct customer_city
FROM ecommerce_schema.customers
WHERE customer_state = 'CE'
UNION
SELECT distinct supplier_city
FROM ecommerce_schema.suppliers
WHERE supplier_state = 'CE';


/*
	INTERSECT
*/


SELECT distinct customer_city
FROM ecommerce_schema.customers
WHERE customer_state = 'CE'
INTERSECT
SELECT distinct supplier_city
FROM ecommerce_schema.suppliers
WHERE supplier_state = 'CE';

/*
	EXCEPT
*/


SELECT distinct customer_city
FROM ecommerce_schema.customers
WHERE customer_state = 'CE'
EXCEPT
SELECT distinct supplier_city
FROM ecommerce_schema.suppliers
WHERE supplier_state = 'CE';


/*

	INNER JOIN

*/

SELECT o.order_id, o.order_status, c.customer_id, c.customer_city
FROM ecommerce_schema.customers as c
INNER JOIN ecommerce_schema.orders as o
ON c.customer_id = o.customer_id;


SELECT c.customer_id, c.customer_name, o.order_id
FROM ecommerce_schema.customers as c
INNER JOIN ecommerce_schema.orders as o
ON c.customer_id = o.customer_id
WHERE customer_city = 'franca'
ORDER BY 3 DESC;

/*

	LEFT OUTER JOIN

*/

SELECT c.customer_id, c.customer_name, o.order_id
FROM ecommerce_schema.customers as c
LEFT JOIN ecommerce_schema.orders as o
ON c.customer_id = o.customer_id
WHERE customer_city = 'franca'
ORDER BY 3 DESC;

/*

	FULL OUTER JOIN

*/

SELECT c.customer_id, c.customer_name, o.order_id
FROM ecommerce_schema.customers as c
FULL OUTER JOIN ecommerce_schema.orders as o
ON c.customer_id = o.customer_id
WHERE customer_city = 'franca'
ORDER BY 3 DESC;