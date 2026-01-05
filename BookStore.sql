CREATE DATABASE online_bookstore;
USE online_bookstore;
create table books (
         Book_ID SERIAL PRIMARY KEY,
         Title VARCHAR(100),
         Author VARCHAR(100),
         Genre VARCHAR(50),
		 Published_Year INT,
         Price NUMERIC(10,2),
         Stock INT
);
CREATE TABLE Customers (
    Customers_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);

CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10,2)
);


SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

-- 1. RETRIVE ALL BOOKS IN THE 'FICTION' GENRE;
SELECT * FROM Books
WHERE Genre ='Fiction';

-- 2. FIND BOOKS PUBLISHED AFTER THE YEAR 1959;
SELECT* FROM Books
WHERE Published_Year>1959;

-- 3. LIST ALL THE CUSTOMERS FROM CANADA
SELECT * FROM Customers
WHERE Country='Canada';

-- 4.SHOW ORDER PLACED IN 'NOV 2023'
SELECT * FROM Orders
WHERE Order_Date BETWEEN '2023-11-01' AND '2023-11-30';

-- 5.RETRIVE THE TOTAL STOCK OF BOOKS AVAILABLE
SELECT SUM(Stock) AS Total_Stock
FROM Books;

-- 6. FIND THE DETAILS OF MOST EXPENSIVE BOOKS
SELECT  *  FROM BOOKS
ORDER BY Price desc 
limit 5;

-- 7. SHOW ALL CUSTOMERS WHO ORDERED MORE THEN 1 QUANTITY OF BOOKS
SELECT * FROM Orders
WHERE Quantity>1; 

-- 8. RETRIVE ALL ORDERS WHERE TOTAL AMT EXCEED $ 20
SELECT * FROM Orders
WHERE Total_Amount > 20;

-- 9. LIST ALL GENRE AVAILABLE IN THE BOOKS
SELECT DISTINCT Genre
FROM Books;

-- 10. FIND THE BOOKS WITH LOWEST STOCK
SELECT * FROM Books
ORDER BY stock DESC
LIMIT 5;

-- 11. CALCULATE TOTAL REVENUE GENERATED FROM ALL ORDERS
SELECT sum(Total_Amount) as REVENUE
FROM Orders;


-- ADVANCE QUREIS
-- 1.RETRIVE THE TOTAL NUMBER OF BOOK SOLD FOR EACH GENRE
SELECT b.Genre, SUM(o.Quantity) AS Books_sold
FROM Orders o 
JOIN Books b ON o.Book_ID = b.Book_ID
Group by b.Genre;

-- 2.FIND THE AVG PRICE OF BOOKS IN THE 'Fantasy' Genre
select avg(Price) as Avg_Price
from Books
where Genre= "Fantasy";

-- 3.LIST CUSTOMERS WHO HAVE PLACED ATLEAST 2  ORDERS
SELECT Customer_ID , COUNT(Order_ID) AS ORDER_COUNT
FROM Orders
Group by Customer_ID
HAVING COUNT(Order_ID) >=2 ;
-- WITH JOIN NAME:
SELECT o.Customer_ID , c.Name,COUNT(o.Order_ID) AS ORDER_COUNT
FROM Orders o
JOIN Customers c ON o.Customer_ID=c.Customers_ID
GROUP BY o.Customer_ID,c.Name
HAVING COUNT(o.Order_ID) >=2 ;

-- 4.FIND MOST FREQUANTLY ORDER BOOKED
SELECT o.Book_ID,b.Genre,COUNT(o.Order_ID) as ORDER_COUNT
FROM Orders o
join Books b ON b.Book_ID=O.Book_id
Group by o.Book_ID , b.Genre
Order by ORDER_COUNT DESC limit 10;

--  5. SHOW THE TOP 3  MOST EXPENCIVE BOOKS OF 'FANTACY' GENRE
SELECT * FROM Books
WHERE Genre='Fantasy'
order by Price desc
limit 3;

-- 6. RETRIVE THE TOTAL QUANTITY OF BOOK SOLD  BY EACH AUTHOR
SELECT  b.Author, SUM(o.Quantity) as 'Total Books Sold'
FROM Orders o 
JOIN Books b ON b.Book_ID = o.Book_ID 
Group by b.Author;

-- 7.LIST THE CITY WHERE CUSTOMERS WHO SPENT OVER $ 30 ARE LOCATED
SELECT c.City, SUM(o.Total_Amount) AS Total_Amount
FROM Orders o
JOIN Customers c 
    ON o.Customer_ID = c.Customers_ID
GROUP BY c.City
HAVING SUM(o.Total_Amount) > 30;
-- OR --
select distinct c.City,o.Total_Amount
from Orders o
join Customers c on o.Customer_ID=c.Customers_id
where Total_Amount > 30

-- 8. FIND THE CUSTOMER WHO SPENT MOST ON ORDERS
SELECT c.Name , SUM(o.Total_Amount) AS Total_Spent
FROM Orders o
JOIN Customers c ON o.Customer_ID = c.Customers_id
GROUP BY c.Name
ORDER BY Total_Spent DESC limit 3;

-- 9. CALCULATE THE STOCK REMAINING AFTER FULFILLING ALL THE ORDERS
SELECT b.Book_ID , b.Title , b.Stock, COALESCE(SUM(o.Quantity),0) AS Order_Quantity,
       b.Stock - COALESCE(SUM(o.Quantity),0)  as Remaining_Quantity
FROM Orders o 
LEFT JOIN Books b ON b.Book_ID = o.Book_ID 
GROUP BY b.Book_ID, b.Title 
ORDER BY b.Book_ID;

