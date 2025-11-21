-- Create the CUSTOMERS table
CREATE TABLE CUSTOMERS (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20) NOT NULL,
    address VARCHAR(255) NOT NULL
);

-- Create the PRODUCTS table
CREATE TABLE PRODUCTS (
    product_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    stock_quantity INT NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0));
    


-- Create the ORDERS table
CREATE TABLE ORDERS (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) NOT NULL DEFAULT 'Pending',
    total_amount DECIMAL(10,2) NOT NULL CHECK (total_amount >= 0),
    CONSTRAINT fk_orders_customers FOREIGN KEY (customer_id)
        REFERENCES CUSTOMERS (customer_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Create the ORDER_DETAILS table
CREATE TABLE ORDER_DETAILS (
    order_detail_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    CONSTRAINT fk_orderdetails_orders FOREIGN KEY (order_id)
        REFERENCES ORDERS(order_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_orderdetails_products FOREIGN KEY (product_id)
        REFERENCES PRODUCTS(product_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- Create the SHIPMENTS table
CREATE TABLE SHIPMENTS (
    shipment_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    shipment_date DATE NOT NULL,
    delivery_date DATE,
    status VARCHAR(20) NOT NULL DEFAULT 'Shipped',
    tracking_number VARCHAR(50) UNIQUE,
    CONSTRAINT fk_shipments_orders FOREIGN KEY (order_id)
        REFERENCES ORDERS(order_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Create the RETURNS table
CREATE TABLE RETURNS (
    return_id INT PRIMARY KEY,
    order_id INT NULL,
    product_id INT NULL,
    return_date DATE NOT NULL,
    reason VARCHAR(255) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Processing',
    CONSTRAINT fk_returns_orders FOREIGN KEY (order_id)
        REFERENCES ORDERS(order_id)
        ON DELETE CASCADE
        ON UPDATE SET NULL,
    CONSTRAINT fk_returns_products FOREIGN KEY (product_id)
        REFERENCES PRODUCTS(product_id)
        ON DELETE SET NULL
        ON UPDATE SET NULL
);

-- Create the REVIEWS table
CREATE TABLE REVIEWS (
    review_id INT PRIMARY KEY,
    product_id INT NULL,
    customer_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    review_date DATE NOT NULL,
    CONSTRAINT fk_reviews_products FOREIGN KEY (product_id)
        REFERENCES PRODUCTS(product_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_reviews_customers FOREIGN KEY (customer_id)
        REFERENCES CUSTOMERS(customer_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);


-- CUSTOMERS
INSERT INTO CUSTOMERS VALUES
(1, 'Amit Sharma', 'amit.sharma@email.com', '9876543210', 'Bangalore, India'),
(2, 'Pooja Singh', 'pooja.singh@email.com', '9876501234', 'Delhi, India'),
(3, 'Rahul Kumar', 'rahul.kumar@email.com', '9812345678', 'Mumbai, India'),
(4, 'Sneha Patel', 'sneha.patel@email.com', '9123456789', 'Ahmedabad, India'),
(5, 'Vikas Roy', 'vikas.roy@email.com', '9001122334', 'Kolkata, India');

-- PRODUCTS (Assuming category_id as 1 for all)
INSERT INTO PRODUCTS VALUES
(1, 'Wireless Mouse', 'Ergonomic Wireless Mouse', 550.00, 80),
(2, 'Mechanical Keyboard', 'RGB Backlit Mechanical Keyboard', 2500.00, 50),
(3, '16GB Pen Drive', 'USB 3.1 High Speed Pen Drive', 700.00, 120),
(4, 'Laptop Stand', 'Adjustable Laptop Stand', 900.00, 40),
(5, 'Bluetooth Speaker', 'Portable Bluetooth Speaker', 1200.00, 60);

-- ORDERS
INSERT INTO ORDERS VALUES
(1, 1, '2025-08-01', 'Shipped', 3200.00),
(2, 2, '2025-08-02', 'Delivered', 1450.00),
(3, 3, '2025-08-03', 'Processing', 900.00),
(4, 4, '2025-08-04', 'Cancelled', 2500.00),
(5, 5, '2025-08-05', 'Shipped', 1950.00);

-- ORDER_DETAILS
INSERT INTO ORDER_DETAILS VALUES
(1, 1, 2, 1, 2500.00),
(2, 1, 5, 1, 1200.00),
(3, 2, 1, 1, 550.00),
(4, 2, 3, 2, 700.00),
(5, 3, 4, 1, 900.00);

-- SHIPMENTS
INSERT INTO SHIPMENTS VALUES
(1, 1, '2025-08-02', '2025-08-05', 'Delivered', 'TRK001'),
(2, 2, '2025-08-03', '2025-08-06', 'Delivered', 'TRK002'),
(3, 3, '2025-08-04', NULL, 'Shipped', 'TRK003'),
(4, 4, '2025-08-06', NULL, 'Cancelled', 'TRK004'),
(5, 5, '2025-08-07', NULL, 'Shipped', 'TRK005');

-- RETURNS
INSERT INTO RETURNS VALUES
(1, 2, 3, '2025-08-09', 'Defective item', 'Processed'),
(2, 1, 5, '2025-08-10', 'Not as described', 'Processing'),
(3, 1, 2, '2025-08-10', 'Wrong item sent', 'Processing'),
(4, 2, 1, '2025-08-11', 'Damaged in transit', 'Processed'),
(5, 3, 4, '2025-08-12', 'Changed mind', 'Pending');

-- REVIEWS
INSERT INTO REVIEWS VALUES
(1, 1, 1, 4, 'Works well, satisfied!', '2025-08-06'),
(2, 3, 2, 5, 'Very fast data transfer.', '2025-08-07'),
(3, 5, 1, 2, 'Poor sound quality.', '2025-08-08'),
(4, 4, 5, 5, 'Sturdy and versatile stand!', '2025-08-09'),
(5, 2, 3, 3, 'Good keyboard, average keys.', '2025-08-10');

DELIMITER //
CREATE TRIGGER update_stock_after_order
AFTER INSERT ON ORDER_DETAILS
FOR EACH ROW
BEGIN
    UPDATE PRODUCTS
    SET stock_quantity = stock_quantity - NEW.quantity
    WHERE product_id = NEW.product_id;
END//
DELIMITER ;

DELIMITER //
CREATE TRIGGER prevent_negative_stock
BEFORE UPDATE ON PRODUCTS
FOR EACH ROW
BEGIN
    IF NEW.stock_quantity < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Stock quantity cannot be negative';
    END IF;
END//
DELIMITER ;

DELIMITER //
CREATE TRIGGER update_order_total
AFTER INSERT ON ORDER_DETAILS
FOR EACH ROW
BEGIN
    UPDATE ORDERS
    SET total_amount = (
        SELECT SUM(quantity * price)
        FROM ORDER_DETAILS
        WHERE order_id = NEW.order_id
    )
    WHERE order_id = NEW.order_id;
END//
DELIMITER ;

DELIMITER //
CREATE TRIGGER log_return_request
AFTER INSERT ON RETURNS
FOR EACH ROW
BEGIN
    IF NEW.status = 'Approved' THEN
        UPDATE PRODUCTS p
        INNER JOIN ORDER_DETAILS od ON p.product_id = od.product_id
        SET p.stock_quantity = p.stock_quantity + od.quantity
        WHERE od.order_id = NEW.order_id 
        AND od.product_id = NEW.product_id;
    END IF;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE get_customer_order_history(IN cust_id INT)
BEGIN
    SELECT 
        o.order_id,
        o.order_date,
        o.status,
        o.total_amount,
        p.name AS product_name,
        od.quantity,
        od.price,
        s.tracking_number,
        s.delivery_date
    FROM ORDERS o
    INNER JOIN ORDER_DETAILS od ON o.order_id = od.order_id
    INNER JOIN PRODUCTS p ON od.product_id = p.product_id
    LEFT JOIN SHIPMENTS s ON o.order_id = s.order_id
    WHERE o.customer_id = cust_id
    ORDER BY o.order_date DESC;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE process_product_return(
    IN p_return_id INT,
    IN p_new_status VARCHAR(20)
)
BEGIN
    DECLARE v_order_id INT;
    DECLARE v_product_id INT;
    DECLARE v_quantity INT;
    
    -- Get return details
    SELECT order_id, product_id INTO v_order_id, v_product_id
    FROM RETURNS WHERE return_id = p_return_id;
    
    -- Get quantity from order details
    SELECT quantity INTO v_quantity
    FROM ORDER_DETAILS WHERE order_id = v_order_id AND product_id = v_product_id;
    
    -- Update return status
    UPDATE RETURNS SET status = p_new_status WHERE return_id = p_return_id;
    
    -- If approved, restore stock
    IF p_new_status = 'Approved' THEN
        UPDATE PRODUCTS SET stock_quantity = stock_quantity + v_quantity WHERE product_id = v_product_id;
    END IF;
    
    SELECT CONCAT('Return #', p_return_id, ' processed successfully. Status: ', p_new_status) AS message;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE generate_sales_report(
    IN start_date DATE,
    IN end_date DATE
)
BEGIN
    SELECT 
        DATE(o.order_date) AS sale_date,
        COUNT(DISTINCT o.order_id) AS total_orders,
        COUNT(DISTINCT o.customer_id) AS unique_customers,
        SUM(od.quantity) AS total_items_sold,
        SUM(od.quantity * od.price) AS total_revenue,
        AVG(o.total_amount) AS avg_order_value
    FROM ORDERS o
    INNER JOIN ORDER_DETAILS od ON o.order_id = od.order_id
    WHERE DATE(o.order_date) BETWEEN start_date AND end_date
    AND o.status != 'Cancelled'
    GROUP BY DATE(o.order_date)
    ORDER BY sale_date DESC;
END//
DELIMITER ;

DELIMITER //
CREATE FUNCTION calculate_product_revenue(prod_id INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total_revenue DECIMAL(10,2);
    SELECT COALESCE(SUM(od.quantity * od.price), 0)
    INTO total_revenue
    FROM ORDER_DETAILS od
    INNER JOIN ORDERS o ON od.order_id = o.order_id
    WHERE od.product_id = prod_id
    AND o.status != 'Cancelled';
    RETURN total_revenue;
END//
DELIMITER ;

DELIMITER //
CREATE FUNCTION calculate_customer_ltv(cust_id INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE lifetime_value DECIMAL(10,2);
    SELECT COALESCE(SUM(total_amount), 0) INTO lifetime_value
    FROM ORDERS WHERE customer_id = cust_id AND status != 'Cancelled';
    RETURN lifetime_value;
END//
DELIMITER ;

DELIMITER //
CREATE FUNCTION get_average_rating(prod_id INT)
RETURNS DECIMAL(3,2)
DETERMINISTIC
BEGIN
    DECLARE avg_rating DECIMAL(3,2);
    SELECT COALESCE(AVG(rating), 0) INTO avg_rating
    FROM REVIEWS WHERE product_id = prod_id;
    RETURN avg_rating;
END//
DELIMITER ;