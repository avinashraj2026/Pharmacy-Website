create database pharmacy_application;
USE pharmacy_application;

CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY, -- Auto-incrementing ID
    username VARCHAR(255) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL, 
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    user_type ENUM('regular_user', 'medical_rep')  
);

CREATE TABLE Medicines (
    medicine_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    generic_name VARCHAR(255), 
    dosage VARCHAR(255),
    form VARCHAR(255), 
    image VARCHAR(255)  -- For an image path
);

CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL, 
    order_status ENUM('pending', 'processing', 'shipped', 'delivered', 'cancelled') NOT NULL, 
    total_price DECIMAL(10, 2) NOT NULL,
    order_date DATETIME NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) -- Foreign Key
);

CREATE TABLE Order_Items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    medicine_id INT NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (medicine_id) REFERENCES Medicines(medicine_id)
);

CREATE TABLE Loyalty_Points (
    loyalty_point_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL, 
    points INT NOT NULL,
    earned_date DATETIME NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) 
);

CREATE TABLE Addresses (
    address_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL, 
    address_line1 VARCHAR(255) NOT NULL,
    -- Consider additional address fields if needed
    FOREIGN KEY (user_id) REFERENCES Users(user_id) 
);

CREATE TABLE Medical_History (
    medical_history_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL, 
    conditions TEXT, -- Adjust datatype if needed
    FOREIGN KEY (user_id) REFERENCES Users(user_id) 
);

CREATE TABLE Medical_Representatives (
    mr_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    region VARCHAR(255)  -- Optional
);

CREATE TABLE Pharmacies (
    pharmacy_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    city VARCHAR(255) NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE -- Default to active
);

CREATE TABLE Inventory (
   inventory_id INT AUTO_INCREMENT PRIMARY KEY,
   medicine_id INT NOT NULL,
   pharmacy_id INT NOT NULL,  
   stock_quantity INT NOT NULL, 
   FOREIGN KEY (medicine_id) REFERENCES Medicines(medicine_id),
   FOREIGN KEY (pharmacy_id) REFERENCES Pharmacies(pharmacy_id)
);

CREATE TABLE Admin_Users (
    admin_user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL, -- Ensure a strong hashing mechanism!
    role ENUM('admin', 'super_admin') NOT NULL  
);

ALTER TABLE Users 
  MODIFY password VARCHAR(255) NOT NULL; -- Adjust VARCHAR length if needed



