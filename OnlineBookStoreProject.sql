-- Create Database
create database OnlineBookstore

--switch to the database
use OnlineBookstore

SELECT * FROM Books
select * FROM Customers
SELECT * FROM Orders
SELECT * FROM Books

-- Making Price column in the Books table round off to 2 decimals values. 

UPDATE Books SET price = ROUND(price, 2)

-- Making Total_Amount column  in the Orders table round off to 2 decimals values. 

UPDATE Orders SET Total_Amount = ROUND(Total_Amount, 2)



-- Add primary key to the Books table 

ALTER TABLE Books ADD CONSTRAINT PK_Books PRIMARY KEY (Book_ID)

--Add primary key to Customers table 

ALTER TABLE Customers ADD CONSTRAINT PK_Customers PRIMARY KEY (Customer_ID)

--Add foreign key for Order_ID in the Orders table

ALTER TABLE Orders ADD CONSTRAINT FK_Orders_Book_ID FOREIGN KEY (Book_ID) REFERENCES Books(Book_ID)

--Add Foreign key for Customer_ID in the Orders table

ALTER TABLE Orders ADD CONSTRAINT FK_Orders_Customer_ID FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID)



--1) Retrieve all books in the "Fiction" genre

SELECT * FROM Books WHERE Genre = 'Fiction'

--2) Find books published after the year 1950

SELECT * FROM Books WHERE Published_Year > 1950

--3) List all customers from the Canada

SELECT * FROM Customers WHERE Country = 'CANADA'

--4) Show orders placed in November 2023

SELECT * FROM Orders WHERE Order_Date BETWEEN '2023-11-01' AND '2023-11-30'

--5) Retrieve the total stock of books available

SELECT SUM(Stock) AS Total_stock FROM Books

--6) Find the details of the most expensive book

SELECT TOP 1 * FROM Books ORDER BY Price DESC

--7) Show all customers who ordered more than 1 quantity of a book

SELECT * FROM Orders WHERE Quantity>1

--8) Retrieve all orders where the total amount exceeds $20

SELECT * FROM Orders WHERE Total_Amount >20

--9) List all genres available in the Books table

SELECT DISTINCT Genre from Books

--10) Find the book with the lowest stock
 
SELECT  TOP 1 * FROM Books ORDER BY Stock 
 
 --11) Calculate the total revenue generated from all orders

SELECT SUM(Total_Amount) as Revenue  FROM Orders



 --1) Retrieve the total number of books sold for each genre

SELECT b.Genre, SUM(o.Quantity) AS Total_Books_Sold 
FROM Orders o 
JOIN Books b ON o.Book_ID = b.Book_ID 
GROUP BY b.Genre


 --2) Find the average price of books in the "Fantasy" genre
 
SELECT AVG(Price) AS Average_Price 
FROM Books
WHERE Genre = 'Fantasy'

 --3) List customers who have placed at least 2 orders

SELECT o.Customer_ID, c.Name, COUNT(Order_ID) AS Order_Count 
FROM Orders o
JOIN Customers c on o.Customer_ID = c.Customer_ID
GROUP BY o.Customer_ID, c.Name
HAVING COUNT(Order_ID) >=2



 --4) Find the most frequently ordered book

 SELECT TOP 1 o.book_id, b.title, 
COUNT(o.order_id) AS Order_count
FROM orders o
JOIN books b ON o.book_id = b.book_id
GROUP BY o.book_id, b.title
ORDER BY Order_count DESC

 
 --5) Show the top 3 most expensive books of "Fantasy" Genre
 
SELECT TOP 3 * FROM Books
WHERE Genre ='Fantasy'
ORDER BY price DESC
 
 --6) Retrieve the total quantity of books sold by each author
 
SELECT b.author, SUM(o.quantity) AS Total_books_sold
FROM Orders o
JOIN Books b ON o.Book_ID = b.Book_ID
GROUP BY b.Author
 
 --7) List the cities where customers who spent over $30 are located

SELECT DISTINCT c.City, Total_Amount
FROM Orders o
JOIN Customers c ON o.Customer_ID = c.Customer_ID
WHERE o.Total_Amount > 30 


 --8) Find the customer who spent the most on orders
 
SELECT TOP 1 c.Customer_id, c.Name, SUM(o.Total_Amount) AS Total_Spent
FROM Orders o
JOIN Customers C ON o.Customer_ID=C.Customer_ID
GROUP BY c.Customer_ID, C.Name
ORDER BY Total_Spent DESC


 --9) Calculate the stock remaining after fulfilling all orders

SELECT b.book_ID, b.title, b.stock, 
COALESCE(SUM(o.quantity), 0) AS Order_quantity,
(b.Stock - COALESCE(SUM(o.quantity), 0)) AS Stock_remaining
FROM Books b 
LEFT JOIN Orders o ON b.Book_ID = o.Book_ID
GROUP BY b.book_ID, b.title, b.stock
