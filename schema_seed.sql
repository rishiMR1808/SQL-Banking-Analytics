USE tempdb;

-- Customers Table
CREATE TABLE #Customers (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(50),
    Age INT,
    Gender VARCHAR(10),
    City VARCHAR(50),
    JoinDate DATE
);

INSERT INTO #Customers (CustomerID, Name, Age, Gender, City, JoinDate) VALUES
(1, 'Amit Sharma', 28, 'Male', 'Delhi', '2021-02-15'),
(2, 'Neha Verma', 34, 'Female', 'Mumbai', '2020-07-10'),
(3, 'Ravi Kumar', 40, 'Male', 'Bangalore', '2019-03-25'),
(4, 'Pooja Singh', 25, 'Female', 'Chennai', '2022-01-05'),
(5, 'Arjun Mehta', 31, 'Male', 'Kolkata', '2021-11-18'),
(6, 'Sneha Patel', 29, 'Female', 'Pune', '2020-05-20'),
(7, 'Rahul Jain', 37, 'Male', 'Delhi', '2019-09-14'),
(8, 'Kavita Iyer', 27, 'Female', 'Mumbai', '2021-06-30');

-- Products Table
CREATE TABLE #Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2),
    StockQuantity INT
);

INSERT INTO #Products (ProductID, ProductName, Category, Price, StockQuantity) VALUES
(101, 'Smartphone', 'Electronics', 15000.00, 50),
(102, 'Laptop', 'Electronics', 55000.00, 30),
(103, 'Headphones', 'Electronics', 2000.00, 100),
(104, 'Shoes', 'Fashion', 2500.00, 80),
(105, 'T-shirt', 'Fashion', 800.00, 120),
(106, 'Refrigerator', 'Appliances', 30000.00, 20),
(107, 'Microwave', 'Appliances', 12000.00, 25),
(108, 'Washing Machine', 'Appliances', 28000.00, 15);

-- Orders Table
CREATE TABLE #Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    TotalAmount DECIMAL(10,2)
);

INSERT INTO #Orders (OrderID, CustomerID, OrderDate, TotalAmount) VALUES
(1001, 1, '2021-03-10', 17000.00),
(1002, 2, '2020-08-05', 55000.00),
(1003, 3, '2020-12-22', 3500.00),
(1004, 4, '2022-02-14', 800.00),
(1005, 5, '2021-12-01', 30000.00),
(1006, 6, '2020-07-20', 15000.00),
(1007, 7, '2021-05-15', 2500.00),
(1008, 8, '2021-07-25', 12000.00),
(1009, 1, '2022-01-10', 2000.00),
(1010, 2, '2021-09-17', 28000.00);

-- OrderDetails Table
CREATE TABLE #OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    LineTotal DECIMAL(10,2)
);

INSERT INTO #OrderDetails (OrderDetailID, OrderID, ProductID, Quantity, LineTotal) VALUES
(1, 1001, 101, 1, 15000.00),
(2, 1001, 103, 1, 2000.00),
(3, 1002, 102, 1, 55000.00),
(4, 1003, 104, 1, 2500.00),
(5, 1003, 105, 1, 1000.00),
(6, 1004, 105, 1, 800.00),
(7, 1005, 106, 1, 30000.00),
(8, 1006, 101, 1, 15000.00),
(9, 1007, 104, 1, 2500.00),
(10, 1008, 107, 1, 12000.00),
(11, 1009, 103, 1, 2000.00),
(12, 1010, 108, 1, 28000.00);
