CREATE TABLE full_table2 (order_id varchar, order_date DATE, ship_date DATE, ship_mode varchar, customer_id varchar, customer_name varchar, segment varchar, country varchar, city varchar, state varchar, postal_code varchar, region varchar, product_id varchar, catgory varchar, sub_category varchar, product_name varchar, sales float,quantity bigint, discount float, profit float)

select * from full_table2;

COPY full_table2(order_id, order_date, ship_date, ship_mode, customer_id, customer_name, segment, country, city, state, postal_code, region, product_id, catgory, sub_category, product_name, sales, quantity, discount, profit)
FROM 'E-commerce sales data.csv'
DELIMITER ','
CSV HEADER
ENCODING 'WIN1252';
