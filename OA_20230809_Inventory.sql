USE [Project]
GO

--DROP TABLE inv_user
CREATE TABLE brands (
    bid INT NOT NULL,
    bname VARCHAR(20) NULL
);
ALTER TABLE brands ADD PRIMARY KEY (bid);


CREATE TABLE inv_user (
    user_id VARCHAR(50) NOT NULL,
    name VARCHAR(50) NULL,
    password VARCHAR(50) NULL,
    last_login datetime NULL,
    user_type VARCHAR(20) NULL
);

ALTER TABLE inv_user ADD PRIMARY KEY (user_id);



CREATE TABLE categories (
    cid INT NOT NULL,
    category_name VARCHAR(20) NULL
);
ALTER TABLE categories ADD PRIMARY KEY (cid);


CREATE TABLE product (
    pid INT PRIMARY KEY NOT NULL,
    cid INT REFERENCES categories(cid) NULL,
    bid INT REFERENCES brands(bid) NULL,
    sid INT NOT NULL,
    pname VARCHAR(20) NULL,
    p_stock INT NULL,
    price INT NULL,
    added_date DATE NULL
);


CREATE TABLE stores (
    sid INT NOT NULL,
    sname VARCHAR(20) NULL,
    address VARCHAR(20) NULL,
    mobno INT NULL
);
ALTER TABLE stores ADD PRIMARY KEY (sid);
ALTER TABLE product ADD FOREIGN KEY (sid) REFERENCES stores(sid);


CREATE TABLE provides (
    bid INT  REFERENCES brands(bid),
    sid INT  REFERENCES stores(sid),
    discount INT 
);


CREATE TABLE customer_cart (
    cust_id INT PRIMARY KEY,
    name VARCHAR(20),
    mobno INT
);


CREATE TABLE select_product (
    cust_id INT REFERENCES customer_cart(cust_id),
    pid INT REFERENCES product(pid),
    quantity INT
);

CREATE TABLE transactions (
    id INT PRIMARY KEY,
    total_amount INT,
    paid INT,
    due INT,
    gst INT,
    discount INT,
    payment_method VARCHAR(10),
    cart_id INT REFERENCES customer_cart(cust_id)
);


CREATE TABLE invoice (
    item_no INT,
    product_name VARCHAR(20),
    quantity INT,
    net_price INT,
    transaction_id INT REFERENCES transactions(id)
);


/*INSERT INTO BRANDS:
INSERT INTO brands (bid, bname) VALUES (1, 'Apple');
INSERT INTO brands (bid, bname) VALUES (2, 'Samsung');
INSERT INTO brands (bid, bname) VALUES (3, 'Nike');
INSERT INTO brands (bid, bname) VALUES (4, 'Fortune');

DELETE FROM brands WHERE bid IN (1, 2, 3, 4);*/

/*OR insert multiple rows at once using a single INSERT statement*/
INSERT INTO brands (bid, bname)
VALUES
    (1, 'Apple'),
    (2, 'Samsung'),
    (3, 'Nike'),
    (4, 'Fortune'); 


/*INSERT INTO INV_USER*/
INSERT INTO inv_user (user_id, name, password, last_login, user_type)
VALUES ('opeyemi.ayanwale@gmail.com', 'Opeyemi Ayanwale', '1234', '31-July-23  12:30', 'admin');

INSERT INTO inv_user (user_id, name, password, last_login, user_type)
VALUES ('mustaphazeezath@gmail.com', 'Mustapha Azeezat', '1111', '30-July-23 11:30', 'Manager');

INSERT INTO inv_user (user_id, name, password, last_login, user_type)
VALUES ('ltnlawal@gmail.com', 'Lawal Olaitan', '0011', '29-July-23 10:30', 'Accountant');


/*INSERT INTO CATEGORIES*/
INSERT INTO categories (cid, category_name) VALUES (1, 'Electronics');
INSERT INTO categories (cid, category_name) VALUES (2, 'Clothing');
INSERT INTO categories (cid, category_name) VALUES (3, 'Grocery');


/*INSERT INTO STORE*/
INSERT INTO stores (sid, sname, address, mobno) VALUES (1, 'Saturn', 'Dortmund', 9999999);
INSERT INTO stores (sid, sname, address, mobno) VALUES (2, 'C&A', 'Dusseldorf', 8888555);
INSERT INTO stores (sid, sname, address, mobno) VALUES (3, 'Rewe', 'Bocum', 7777555);

DELETE FROM stores
WHERE sid = 2;

INSERT INTO stores (sid, sname, address, mobno) VALUES (2, 'Nike', 'Dusseldorf', 8888555);



/*INSERT INTO PRODUCT*/
INSERT INTO product (pid, cid, bid, sid, pname, p_stock, price, added_date)
VALUES (1, 1, 1, 1, 'IPHONE', 4, 1400, '2023-07-31');

INSERT INTO product (pid, cid, bid, sid, pname, p_stock, price, added_date)
VALUES (2, 1, 1, 1, 'Airpods', 3, 200, '2023-07-27');

INSERT INTO product (pid, cid, bid, sid, pname, p_stock, price, added_date)
VALUES (3, 1, 1, 1, 'Smart Watch', 3, 500, '2023-07-27');

INSERT INTO product (pid, cid, bid, sid, pname, p_stock, price, added_date)
VALUES (4, 2, 3, 2, 'Air Max', 6, 150, '2023-07-27');

INSERT INTO product (pid, cid, bid, sid, pname, p_stock, price, added_date)
VALUES (5, 3, 4, 3, 'REFINED OIL', 6, 50, '2023-07-25');


-- INSERT INTO PROVIDES:
INSERT INTO provides (bid, sid, discount) VALUES (1, 1, 12);
INSERT INTO provides (bid, sid, discount) VALUES (2, 2, 7);
INSERT INTO provides (bid, sid, discount) VALUES (3, 3, 15);
INSERT INTO provides (bid, sid, discount) VALUES (1, 2, 7);
INSERT INTO provides (bid, sid, discount) VALUES (4, 2, 19);
INSERT INTO provides (bid, sid, discount) VALUES (4, 3, 20);


-- INSERT INTO CUSTOMER_CART:
INSERT INTO customer_cart (cust_id, name, mobno) VALUES (1, 'Fola', 76543210);
INSERT INTO customer_cart (cust_id, name, mobno) VALUES (2, 'Tope', 77777777);
INSERT INTO customer_cart (cust_id, name, mobno) VALUES (3, 'Dipo', 77777775);


-- INSERT INTO SELECT_PRODUCT:
INSERT INTO select_product (cust_id, pid, quantity) VALUES (1, 2, 2);
INSERT INTO select_product (cust_id, pid, quantity) VALUES (1, 3, 1);
INSERT INTO select_product (cust_id, pid, quantity) VALUES (2, 3, 3);
INSERT INTO select_product (cust_id, pid, quantity) VALUES (3, 2, 1);

-- INSERT INTO TRANSACTIONS:
INSERT INTO transactions (id, total_amount, paid, due, gst, discount, payment_method, cart_id)
VALUES (1, 7000, 2000, 5000, 350, 350, 'card', 1);

INSERT INTO transactions (id, total_amount, paid, due, gst, discount, payment_method, cart_id)
VALUES (2, 7000, 7000, 0, 570, 570, 'cash', 2);

INSERT INTO transactions (id, total_amount, paid, due, gst, discount, payment_method, cart_id)
VALUES (3, 19000, 17000, 2000, 190, 190, 'cash', 3);



--Functions
DECLARE @due1 INT;
DECLARE @cart_id1 INT;


SET @cart_id1 = dbo.get_cart(1);

SELECT @due1 = due FROM [transactions] WHERE cart_id = @cart_id1;

PRINT CAST(@due1 AS NVARCHAR(20)); ---5000 for ouput


--Cursor Equivalent:
DECLARE @p_id INT, @p_name VARCHAR(20), @p_stock INT;
DECLARE p_product CURSOR FOR
    SELECT pid, pname, p_stock FROM product;

OPEN p_product;
FETCH NEXT FROM p_product INTO @p_id, @p_name, @p_stock;

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT CAST(@p_id AS NVARCHAR(10)) + ' ' + @p_name + ' ' + CAST(@p_stock AS NVARCHAR(10));
    FETCH NEXT FROM p_product INTO @p_id, @p_name, @p_stock;
END

CLOSE p_product;
DEALLOCATE p_product;
--cursor named p_product that selects data from the product table. 
--It then iterates through the cursor and fetches each row, printing 
--the values of pid, pname, and p_stock for each row.


---- Create a procedure
-- Use this batch to declare variables and create the procedure
DECLARE @a INT, @b INT;

-- Create a procedure

CREATE PROCEDURE CheckStock
    @x INT
AS
BEGIN
    IF @x < 2
        PRINT 'Stock is Less';
    ELSE
        PRINT 'Enough Stock';
END;
GO

-- Declare and set variables
DECLARE @a INT, @b INT;
SET @b = 2;

-- Call the procedure
SELECT @a = p_stock FROM product WHERE pid = @b;
EXEC CheckStock @a;
---output should be enough stock


--Retrieve all brands:
SELECT * FROM brands;

--Retrieve products with their category and brand names:
SELECT p.pid, p.pname, c.category_name, b.bname
FROM product p
JOIN categories c ON p.cid = c.cid
JOIN brands b ON p.bid = b.bid;

--Retrieve stores and their details:
SELECT * FROM stores;


--Retrieve products available in a specific store:
SELECT p.pname, s.sname, p.p_stock
FROM product p
JOIN stores s ON p.sid = s.sid
WHERE s.sname = 'Saturn';


--Retrieve transaction details for a specific customer's cart:
SELECT t.id, t.total_amount, t.paid, t.due, t.gst, t.discount, t.payment_method
FROM transactions t
JOIN customer_cart cc ON t.cart_id = cc.cust_id
WHERE cc.cust_id = 1;


--Retrieve products and their quantities selected by a customer:
SELECT c.name, p.pname, sp.quantity
FROM select_product sp
JOIN customer_cart c ON sp.cust_id = c.cust_id
JOIN product p ON sp.pid = p.pid
WHERE c.cust_id = 1;


--Retrieve categories and the number of products in each category:
SELECT c.category_name, COUNT(p.pid) AS product_count
FROM categories c
LEFT JOIN product p ON c.cid = p.cid
GROUP BY c.category_name;


--Retrieve total revenue from all transactions:
SELECT SUM(total_amount) AS total_revenue
FROM transactions;
