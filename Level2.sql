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

/*

	SUB QUERY
*/

 -- get all the customers whose name ends with 'n' and their city is 'franca'
select * from 
(select * from ecommerce_schema.customers where customer_name like '%n')
where customer_city = 'franca';

select isbn, ROUND(avg(book_rating), 2) from books_schema.ratings group by isbn;

select * from books_schema.ratings limit 10;

select * from books_schema.books2 limit 10;

-- get all the publishers and their average ratings of their books
select publisher, ROUND(avg(book_rating), 2) as avg_book_rating
FROM (select publisher, book_rating from books_schema.books2 b
	INNER JOIN books_schema.ratings r
	ON b.isbn = r.isbn) as x
GROUP BY publisher
ORDER BY avg_book_rating DESC;

select publisher, count(book_title) from books_schema.books2
group by publisher;

-- get list of publishers and the count of their books published with the average rating of the books, where average is >= 8
select publisher, ROUND(AVG(r.book_rating),2) as avg_book_rating, COUNT(book_title) as books_published
from books_schema.books2 b
INNER JOIN books_schema.ratings r
ON b.isbn = r.isbn
GROUP BY publisher
HAVING AVG(r.book_rating) >= 8
ORDER BY avg_book_rating ASC;

select * from books_schema.books2 where publisher='AMC Publishing';
select * from books_schema.ratings where isbn='929638298';

/*

	CASE

*/

select user_id, age, country,
	CASE gender
		WHEN 'M' THEN 'Male'
		ELSE 'Female'
	END AS gender
from books_schema.users;

select user_id, country, age,
	CASE 
		WHEN age <=14 THEN 'Child'
		WHEN age > 14 and age <= 18 THEN 'Teenager'
		WHEN age > 18 AND age <= 60 THEN 'Adult'
		ELSE 'Senior'
	END AS age_category
from books_schema.users;


/*

	WINDOW FUNCTIONS (OVER and PARTITION BY)

	OVER - transform a function to a window function
	PARTITION - divides the rows into partitions of the same values
	
*/

-- List of users & for each user present also the average age of users living in the same city

SELECT user_id, age, city, state, round(avg(age) OVER (PARTITION BY city), 2) as avg_age
from books_schema.users
WHERE city IS NOT NULL
AND city ~ '^[A-Za-z]+$'; -- regex to check for only cities having alphabets in the city name

-- ROW_NUMBER() window function
-- what's happening is we made paritions by city and order the partitions by age DESC, and assigned each row in a partition a number
-- starting from 1 to the last row in that partition
-- That's why we can see whenever the city name changes the counting starts from the beginning
SELECT user_id, age, city, ROW_NUMBER() OVER (PARTITION BY city ORDER BY age DESC) as row_num
from books_schema.users
WHERE city IS NOT NULL
AND city ~ '^[A-Za-z]+$';


-- The oldest user per city

SELECT * FROM (
	SELECT user_id, age, city, state, ROW_NUMBER() OVER (PARTITION BY city ORDER BY age DESC) as row_num
	from books_schema.users
	WHERE city IS NOT NULL
	AND city ~ '^[A-Za-z]+$'
)
WHERE row_num = 1;

-- RANK() Window Function

SELECT * FROM (
	SELECT user_id, age, city, state,
	RANK() OVER (PARTITION BY city ORDER BY age DESC) as rank_num
	FROM books_schema.users
	WHERE city IS NOT NULL
	AND city ~ '^[A-Za-z]+$'
)
where state = 'seoul';

select * from books_schema.users
WHERE state IS NOT NULL
AND state = 'seoul';

/*

	Virtual Tables (Views)
	-- Looking on data coming from single/ multiple tables without replicating the data
	-- a view is query stored in the database dictionary
	-- computed on demand by the database server

*/

CREATE VIEW books_schema.users_vw AS (
	SELECT user_id, age, country,
		CASE gender
			WHEN 'M' THEN 'Male'
			ELSE 'Female'
		END AS gender
	FROM books_schema.users
);

SELECT * FROM books_schema.users_vw;

CREATE VIEW books_schema.books_vw as (
	SELECT * 
	FROM books_schema.books1
	UNION
	SELECT *
	FROM books_schema.books2
);

select * from books_schema.books_vw;

/*

	CTE - Common Table Expression

*/

WITH avg_book_ratings_CTE 
AS 
(
	SELECT isbn, AVG(book_rating) AS avg_rating
	FROM books_schema.ratings
	GROUP BY isbn
)

SELECT max(avg_rating) as max_avg_rating
FROM avg_book_ratings_CTE;