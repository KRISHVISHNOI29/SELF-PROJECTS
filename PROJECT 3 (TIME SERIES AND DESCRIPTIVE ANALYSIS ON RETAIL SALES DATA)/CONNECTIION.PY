import psycopg2 as pg

conn = pg.connect(
    host='localhost',
    user='postgres',
    database='MINI PROJECT',
    password='KRISH212223'
)

cursor = conn.cursor()

cursor.execute('CREATE TABLE full_table(order_id TEXT, order_date TEXT, ship_date TEXT, ship_mode TEXT, customer_id TEXT, customer_name TEXT, segment TEXT, country TEXT, city TEXT, state TEXT, postal_code TEXT,region TEXT,product_id TEXT,category TEXT,sub_category TEXT, product_name TEXT, sales TEXT,quantity TEXT, discount TEXT, profit TEXT);')
cursor.execute('select * from full_table;')
cursor.execute('copy full_table(order_id TEXT, order_date TEXT, ship_date TEXT, ship_mode TEXT, customer_id TEXT, customer_name TEXT, segment TEXT, country TEXT, city TEXT, state TEXT, postal_code TEXT,region TEXT,product_id TEXT,category TEXT,sub_category TEXT, product_name TEXT, sales TEXT,quantity TEXT, discount TEXT, profit TEXT) FROM 'E-commerce sales data.csv' DELIMETER ',' CSV HEADER;')
print(cursor.fetchone())
conn.close()