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

INSERT INTO Users (username, email, password, first_name, last_name, user_type) 
VALUES ('testuser1', 'test1@example.com', 'hashed_password1', 'Test', 'User', 'regular_user');

-- User 2 
INSERT INTO Users (username, email, password, first_name, last_name, user_type) 
VALUES ('janedoe', 'jane@example.com', 'hashed_password2', 'Jane', 'Doe', 'regular_user');

-- User 3 (Medical Representative)
INSERT INTO Users (username, email, password, first_name, last_name, user_type) 
VALUES ('medrep1', 'medrep@example.com', 'hashed_password3', 'Medical', 'Rep', 'medical_rep');

-- New session
use pharmacy_application;
select * from users;

-- Category: Pain Relief
INSERT INTO Medicines (name, generic_name, dosage, form)
VALUES ('Ibuprofen', 'Ibuprofen', '400mg', 'Tablets'),
       ('Naproxen', 'Naproxen Sodium', '220mg', 'Tablets'), 
       ('Acetaminophen', 'Paracetamol', '500mg', 'Tablets');

-- Category: Antibiotics
INSERT INTO Medicines (name, generic_name, dosage, form)
VALUES ('Amoxicillin', 'Amoxicillin', '500mg', 'Capsules'), 
       ('Cephalexin', 'Cephalexin', '500mg', 'Capsules'), 
       ('Azithromycin', 'Azithromycin', '500mg', 'Tablets'); 

-- Category: Heart Medications
INSERT INTO Medicines (name, generic_name, dosage, form)
VALUES ('Lisinopril', 'Lisinopril', '20mg', 'Tablets'), 
       ('Atorvastatin', 'Atorvastatin Calcium', '10mg', 'Tablets'), 
       ('Metoprolol', 'Metoprolol Succinate', '50mg', 'Tablets'); 

-- Category: Diabetes 
INSERT INTO Medicines (name, generic_name, dosage, form)
VALUES ('Metformin', 'Metformin Hydrochloride', '500mg', 'Tablets'), 
       ('Glipizide', 'Glipizide', '5mg', 'Tablets'), 
       ('Insulin Lispro', 'Insulin Lispro', '100 units/mL', 'Injection'); 

-- Category: Allergy & Asthma
INSERT INTO Medicines (name, generic_name, dosage, form)
VALUES ('Cetirizine', 'Cetirizine Hydrochloride', '10mg', 'Tablets'), 
       ('Loratadine', 'Loratadine', '10mg', 'Tablets'), 
       ('Albuterol Inhaler', 'Albuterol Sulfate', '90 mcg/actuation', 'Inhaler'); 

-- Category: Pain Relief
INSERT INTO Medicines (name, dosage, form, image) 
VALUES ('Ibuprofen', '400mg', 'Tablets', 'https://example.com/ibuprofen.jpg');

INSERT INTO Medicines (name, generic_name, dosage, form, image) 
VALUES ('Aspirin', 'Acetylsalicylic Acid', '325mg', 'Tablets', 'https://example.com/aspirin.jpg'); 

-- Category: Antibiotics
INSERT INTO Medicines (name, generic_name, dosage, form, image) 
VALUES ('Penicillin', 'Penicillin V Potassium', '500mg', 'Tablets', 'https://example.com/penicillin.jpg');


select * from medicines;
CREATE TABLE Prices (
    price_id INT PRIMARY KEY AUTO_INCREMENT,
    medicine_id INT,
    price DECIMAL(10, 2),
    currency VARCHAR(3),
    FOREIGN KEY (medicine_id) REFERENCES Medicines(medicine_id) 
);

INSERT INTO Prices (medicine_id, price, currency) 
VALUES (1, 25.00, 'INR'), 
       (2, 20.50, 'INR'), 
       (3, 18.99, 'INR'),    
       (4, 40.50, 'INR'),
       (5, 75.00, 'INR'),   
       (6, 12.00, 'INR'),     
       (7, 28.00, 'INR'),
       (8, 9.99, 'INR'),   
       (9, 105.00, 'INR'), 
       (10, 32.00, 'INR'),
       (11, 58.00, 'INR'),
       (12, 64.00, 'INR'),
       (13, 15.50, 'INR'),
       (14, 44.99, 'INR'),
       (15, 92.00, 'INR'), 
       (16, 19.50, 'INR'),
       (17, 35.00, 'INR'),
       (18, 51.00, 'INR'); 

CREATE TABLE Cart (
    cart_id INT AUTO_INCREMENT PRIMARY KEY, -- Auto-incrementing ID  
    user_id INT, -- Links to the user
    medicine_id INT, -- Links to the specific medicine
    quantity INT, 
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (medicine_id) REFERENCES Medicines(medicine_id)
);

select * from medicines;
UPDATE Medicines SET image = 'https://c8.alamy.com/comp/DWADBW/penicillin-antibiotics-box-of-28-penicillin-vk-tablets-antibiotic-DWADBW.jpg' WHERE medicine_id = 18; 
UPDATE Medicines SET image = 'https://t4.ftcdn.net/jpg/03/20/34/03/360_F_320340368_3S52L7ICrOQTWmbaTbPtxzwtgJXttUrm.jpg' WHERE medicine_id = 1; 
UPDATE Medicines SET image = 'https://www.shutterstock.com/image-illustration/amoxicillin-antibiotic-medication-used-treat-600nw-2225010241.jpg' WHERE medicine_id = 4; 

select * from prices natural join medicines;
