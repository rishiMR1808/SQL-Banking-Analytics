USE tempdb;

-- Customers
CREATE TABLE #Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(100),
    Age INT,
    City VARCHAR(50),
    JoinDate DATE
);

-- Accounts
CREATE TABLE #Accounts (
    AccountID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT FOREIGN KEY REFERENCES #Customers(CustomerID),
    AccountType VARCHAR(20), -- Savings, Trading, Loan
    Balance DECIMAL(18,2)
);

-- StockTrades
CREATE TABLE #StockTrades (
    TradeID INT IDENTITY(1,1) PRIMARY KEY,
    AccountID INT FOREIGN KEY REFERENCES #Accounts(AccountID),
    StockSymbol VARCHAR(10),
    TradeDate DATE,
    TradeType VARCHAR(4), -- BUY or SELL
    Quantity INT,
    PricePerShare DECIMAL(18,2),
    TotalValue AS (Quantity * PricePerShare) PERSISTED
);

-- Transactions
CREATE TABLE #Transactions (
    TransactionID INT IDENTITY(1,1) PRIMARY KEY,
    AccountID INT FOREIGN KEY REFERENCES #Accounts(AccountID),
    TransactionDate DATE,
    Type VARCHAR(20), -- Deposit, Withdrawal, Transfer
    Amount DECIMAL(18,2)
);

-- Loans
CREATE TABLE #Loans (
    LoanID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT FOREIGN KEY REFERENCES #Customers(CustomerID),
    LoanType VARCHAR(20), -- Home, Personal, Auto
    LoanAmount DECIMAL(18,2),
    InterestRate DECIMAL(5,2),
    StartDate DATE,
    EndDate DATE,
    Status VARCHAR(20) -- Active, Closed, Default
);

-- Seed: Customers
INSERT INTO #Customers (Name, Age, City, JoinDate) VALUES
('Alice Johnson', 34, 'New York', '2018-01-15'),
('Bob Smith', 45, 'Los Angeles', '2017-03-22'),
('Charlie Brown', 29, 'Chicago', '2019-07-10'),
('David Lee', 52, 'Houston', '2016-11-05'),
('Eva Green', 38, 'Phoenix', '2020-02-18'),
('Frank White', 41, 'Philadelphia', '2015-06-12'),
('Grace Kim', 27, 'San Antonio', '2021-09-03'),
('Hannah Scott', 31, 'San Diego', '2018-12-25'),
('Ian Clark', 36, 'Dallas', '2019-04-20'),
('Jane Adams', 49, 'San Jose', '2017-08-14'),
('Kevin Turner', 33, 'Austin', '2020-05-11'),
('Laura Hill', 42, 'Jacksonville', '2016-10-07'),
('Mike Davis', 30, 'Fort Worth', '2019-01-29'),
('Nina Patel', 28, 'Columbus', '2021-03-17'),
('Oscar Reed', 39, 'Charlotte', '2018-06-22'),
('Paula Brooks', 44, 'San Francisco', '2017-09-13'),
('Quinn Taylor', 26, 'Indianapolis', '2022-02-28'),
('Rachel Lewis', 37, 'Seattle', '2019-11-30'),
('Sam Wilson', 40, 'Denver', '2016-08-19'),
('Tina Hall', 32, 'Washington', '2020-07-21');

-- Seed: Accounts (1–2 per customer)
INSERT INTO #Accounts (CustomerID, AccountType, Balance)
SELECT CustomerID, 'Savings', ROUND(RAND(CHECKSUM(NEWID()))*10000+1000,2) FROM #Customers
UNION ALL
SELECT CustomerID, 'Trading', ROUND(RAND(CHECKSUM(NEWID()))*50000+5000,2) FROM #Customers;

-- Seed: StockTrades (sample)
INSERT INTO #StockTrades (AccountID, StockSymbol, TradeDate, TradeType, Quantity, PricePerShare) VALUES
(1,'AAPL','2023-01-10','BUY',50,150.25),
(2,'TSLA','2023-02-15','SELL',20,720.50),
(3,'MSFT','2023-03-20','BUY',30,300.10),
(4,'GOOG','2023-04-12','SELL',10,2800.75),
(5,'AMZN','2023-05-05','BUY',15,3300.50);

-- Seed: Transactions (sample)
INSERT INTO #Transactions (AccountID, TransactionDate, Type, Amount) VALUES
(1,'2023-01-05','Deposit',5000),
(2,'2023-02-10','Withdrawal',1200),
(3,'2023-03-15','Deposit',3500),
(4,'2023-04-08','Transfer',1500),
(5,'2023-05-02','Deposit',4000);

-- Seed: Loans (sample)
INSERT INTO #Loans (CustomerID, LoanType, LoanAmount, InterestRate, StartDate, EndDate, Status) VALUES
(1,'Home',250000,6.5,'2020-01-01','2030-01-01','Active'),
(2,'Personal',15000,10.0,'2019-06-15','2024-06-15','Closed'),
(3,'Auto',20000,8.0,'2021-03-10','2026-03-10','Active'),
(4,'Home',300000,7.0,'2018-09-05','2038-09-05','Default'),
(5,'Personal',12000,9.5,'2022-05-12','2027-05-12','Active');
