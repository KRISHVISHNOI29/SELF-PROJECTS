COPY full_table(order_id, order_date, ship_date, ship_mode, customer_id, customer_name, segment, country, city, state, postal_code, region, product_id, category, sub_category, product_name, sales, quantity, discount, profit)
FROM 'E-commerce sales data.csv'
DELIMITER ','
CSV HEADER
ENCODING 'WIN1252';

-- CREATING AND INSERTING DATA INTO CUSTOMER TABLE 
CREATE TABLE customer_details(customer_id TEXT PRIMARY KEY, customer_name TEXT, segment TEXT);

INSERT INTO customer_details(customer_id, customer_name, segment)
SELECT DISTINCT customer_id, customer_name, segment
FROM full_table;


-- CREATING AND INSERTING DATA IN ORDER TABLE
CREATE TABLE order_details(order_id TEXT PRIMARY KEY, order_date DATE, customer_id TEXT);

INSERT INTO order_details(order_id, order_date, customer_id)
SELECT DISTINCT order_id, order_date, customer_id
FROM full_table;

ALTER TABLE order_details
ADD CONSTRAINT order_foreignkey 
FOREIGN KEY (customer_id) REFERENCES customer_details(customer_id);

ALTER TABLE order_details
ADD CONSTRAINT order_foreignkey2 
FOREIGN KEY (order_id) REFERENCES order_details(order_id);

-- CREATING AND INSERTING DATA INTO SHIPPING DETAILS
CREATE TABLE shipping_details(order_id TEXT PRIMARY KEY, ship_date DATE, ship_mode TEXT);

INSERT INTO shipping_details(order_id, ship_date, ship_mode)
SELECT DISTINCT order_id, ship_date, ship_mode
FROM full_table;

ALTER TABLE shipping_details
ADD CONSTRAINT shipping_foreignkey FOREIGN KEY (order_id) REFERENCES order_details(order_id);


-- CREATING AND INSERTING DATA INTO ADDRESS TABLE 
CREATE TABLE address_details(order_id TEXT PRIMARY KEY, postal_code TEXT);

INSERT INTO address_details(order_id, postal_code)
SELECT DISTINCT order_id, postal_code
FROM full_table;

ALTER TABLE address_details
ADD CONSTRAINT address_foreignkey
FOREIGN KEY (order_id) REFERENCES order_details(order_id);


-- CREATING AND INSERTING DATA INTO POSTAL DETAILS
CREATE TABLE postal_details(postal_code TEXT, city TEXT, state TEXT, country TEXT, region TEXT);

INSERT INTO postal_details(postal_code, city, state, country, region)
SELECT DISTINCT postal_code, city, state, country, region
FROM full_table;

ALTER TABLE postal_details
ADD CONSTRAINT postal_compositekey
PRIMARY KEY (postal_code, city);


--CREATING AND INSERTING DATA INTO PRODUCT TABLE
CREATE TABLE PRODUCT_DETAILS(product_id TEXT, category TEXT, sub_category TEXT, product_name TEXT);

INSERT INTO product_details(product_id, category, sub_category, product_name)
SELECT DISTINCT product_id, category, sub_category, product_name
FROM full_table;

CREATE MATERIALIZED VIEW error_products2 AS
SELECT product_id, COUNT(*)
FROM product_details
GROUP BY product_id
HAVING COUNT(*)>1;

TRUNCATE TABLE product_details;

SELECT product_id,product_name  FROM full_table
WHERE product_id = 'TEC-PH-10001795';

UPDATE  full_table
SET product_id ='TEC-PH-10001796'
WHERE product_id='TEC-PH-10001795' AND product_name='RCA H5401RE1 DECT 6.0 4-Line Cordless Handset With Caller ID/Call Waiting'

ALTER TABLE product_details
ADD CONSTRAINT product_pkey
PRIMARY KEY (product_id);


-- CEREATING AND INSERTING DATA INTO SALES TABLE 
CREATE TABLE sales_details(order_id TEXT, product_id TEXT, quantity INT, discount FLOAT, profit FLOAT);

INSERT INTO sales_details
SELECT
    order_id,
    product_id,
    SUM(quantity) AS quantity,
    SUM(discount) AS discount,
    SUM(profit) AS profit
FROM full_table
GROUP BY order_id, product_id
ORDER BY order_id, product_id;

ALTER TABLE sales_details
ADD CONSTRAINT sales_detailspkey
PRIMARY KEY (order_id, product_id);

SELECT order_id, product_id
FROM sales_details
GROUP BY order_id, product_id
HAVING COUNT(*)>1;
