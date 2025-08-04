--Creating The Tables
-- Create table "Branch"
DROP TABLE IF EXISTS branch;
CREATE TABLE branch
(
            branch_id VARCHAR(10) PRIMARY KEY,
            manager_id VARCHAR(10),
            branch_address VARCHAR(30),
            contact_no VARCHAR(15)
);


-- Create table "Employee"
DROP TABLE IF EXISTS employees;
CREATE TABLE employees
(
            emp_id VARCHAR(10) PRIMARY KEY,
            emp_name VARCHAR(30),
            position VARCHAR(30),
            salary DECIMAL(10,2),
            branch_id VARCHAR(10),
            FOREIGN KEY (branch_id) REFERENCES  branch(branch_id)
);


-- Create table "Members"
DROP TABLE IF EXISTS members;
CREATE TABLE members
(
            member_id VARCHAR(10) PRIMARY KEY,
            member_name VARCHAR(30),
            member_address VARCHAR(30),
            reg_date DATE
);



-- Create table "Books"
DROP TABLE IF EXISTS books;
CREATE TABLE books
(
            isbn VARCHAR(50) PRIMARY KEY,
            book_title VARCHAR(80),
            category VARCHAR(30),
            rental_price DECIMAL(10,2),
            status VARCHAR(10),
            author VARCHAR(30),
            publisher VARCHAR(30)
);



-- Create table "IssueStatus"
DROP TABLE IF EXISTS issued_status;
CREATE TABLE issued_status
(
            issued_id VARCHAR(10) PRIMARY KEY,
            issued_member_id VARCHAR(30),
            issued_book_name VARCHAR(80),
            issued_date DATE,
            issued_book_isbn VARCHAR(50),
            issued_emp_id VARCHAR(10),
            FOREIGN KEY (issued_member_id) REFERENCES members(member_id),
            FOREIGN KEY (issued_emp_id) REFERENCES employees(emp_id),
            FOREIGN KEY (issued_book_isbn) REFERENCES books(isbn) 
);



-- Create table "ReturnStatus"
DROP TABLE IF EXISTS return_status;
CREATE TABLE return_status
(
            return_id VARCHAR(10) PRIMARY KEY,
            issued_id VARCHAR(30),
            return_book_name VARCHAR(80),
            return_date DATE,
            return_book_isbn VARCHAR(50),
            FOREIGN KEY (return_book_isbn) REFERENCES books(isbn)
);

INSERT INTO return_status(return_id, issued_id, return_date) 
VALUES
('RS101', 'IS101', '2023-06-06'),
('RS102', 'IS105', '2023-06-07'),
('RS103', 'IS103', '2023-08-07'),
('RS104', 'IS106', '2024-05-01'),
('RS105', 'IS107', '2024-05-03'),
('RS106', 'IS108', '2024-05-05'),
('RS107', 'IS109', '2024-05-07'),
('RS108', 'IS110', '2024-05-09'),
('RS109', 'IS111', '2024-05-11'),
('RS110', 'IS112', '2024-05-13'),
('RS111', 'IS113', '2024-05-15'),
('RS112', 'IS114', '2024-05-17'),
('RS113', 'IS115', '2024-05-19'),
('RS114', 'IS116', '2024-05-21'),
('RS115', 'IS117', '2024-05-23'),
('RS116', 'IS118', '2024-05-25'),
('RS117', 'IS119', '2024-05-27'),
('RS118', 'IS120', '2024-05-29');

INSERT INTO books VALUES ('978-1-60129-456-2' , 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')

DELETE FROM issued_status 
WHERE issued_id = 'IS104';

-- Exploring Each Table 
SELECT *
FROM books;
SELECT *
FROM branch;
SELECT *
FROM employees;
SELECT *
FROM issued_status;
SELECT *
FROM members;
SELECT *
FROM return_status;

--Data Analysis
--Who are the members issued more than 1 book?
SELECT m.member_id, COUNT(i.issued_id)
FROM members AS m
JOIN issued_status AS i
ON m.member_id=i.issued_member_id
GROUP BY 1
HAVING COUNT(i.issued_id) >1
ORDER BY 2 

--Creating table that have each book and total book_issued_cnt
CREATE TABLE book_cnts
AS    
SELECT 
    b.isbn,
    b.book_title,
    COUNT(ist.issued_id) as no_issued
FROM books as b
JOIN
issued_status as ist
ON ist.issued_book_isbn = b.isbn
GROUP BY 1, 2;

SELECT * FROM book_cnts;

-- What is the most common book category?
SELECT category ,COUNT(isbn) AS num_books
FROM books
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1

--What is total rental price for each category?
SELECT 
    b.category,
    SUM(b.rental_price) as total_rental_price
FROM books as b
JOIN
issued_status as ist
ON ist.issued_book_isbn = b.isbn
GROUP BY 1
ORDER BY 2 DESC

--List each employee and their branch details
SELECT e.*,
    br.manager_id,
    e2.emp_name as manager 
FROM employees AS e
JOIN branch AS br
ON e.branch_id = br.branch_id
JOIN  employees AS e2
ON e2.emp_id = br.manager_id

--List books are not returned yet 
SELECT DISTINCT i.issued_book_isbn,i.issued_book_name
FROM issued_status AS i
LEFT JOIN return_status AS r
ON i.issued_id= r.issued_id
WHERE r.return_id is NULL

--Who are the members who didn't return the book and the allowed number of days (e.g., 30 days) has passed?
SELECT m.member_name,b.book_title,(CURRENT_DATE-i.issued_date) as num_of_days
FROM members as m 
JOIN issued_status as i 
ON m.member_id = i.issued_member_id
JOIN books as b 
ON b.isbn = i.issued_book_isbn
LEFT JOIN return_status as r 
ON i.issued_id = r.issued_id
WHERE r.return_date is NULL AND 
 (CURRENT_DATE-i.issued_date) >30
 ORDER BY 3

--Performance report for each branch ?
SELECT br.branch_id, COUNT(i.issued_id) as Num_of_issued_books, COUNT(r.return_id) as Num_of_returned_books,
SUM(b.rental_price)
FROM branch as br
JOIN employees as e 
ON e.branch_id = br.branch_id
JOIN issued_status as i 
ON e.emp_id = i.issued_emp_id
JOIN books as b 
ON b.isbn = i.issued_book_isbn
LEFT JOIN return_status as r 
ON i.issued_id = r.issued_id
GROUP BY 1
ORDER BY 4 DESC

--Who are the active members who have issued at least one book in the last 6 months?
SELECT m.member_id ,m.member_name
FROM members as m 
JOIN issued_status as i 
ON m.member_id = i.issued_member_id 
WHERE 
i.issued_date >=CURRENT_DATE - INTERVAL '6 month'
GROUP BY 1
HAVING 
COUNT(i.issued_id)>=1 

-- WHO are the Employees with the Most Book Issues Processed?
SELECT e.emp_id,e.emp_name, br.branch_id, COUNT(i.issued_id)
FROM branch as br
JOIN employees as e 
ON e.branch_id = br.branch_id
JOIN issued_status as i 
ON e.emp_id = i.issued_emp_id
GROUP BY 1,2,3
ORDER BY 4 DESC

--Create a stored procedure that updates the status of a book in the library based on its issuance. 
CREATE PROCEDURE issue_book(p_issued_id VARCHAR(10), p_member_id VARCHAR(30),  p_issued_emp_id VARCHAR(10),book_id VARCHAR(50))
LANGUAGE plpgsql
AS $$
DECLARE book_status VARCHAR(10);
BEGIN
    SELECT status 
	INTO book_status
	FROM books
	WHERE isbn=book_id;

	IF book_status ='yes' THEN 
	INSERT INTO issued_status  (issued_id	,issued_member_id ,	issued_date	,issued_book_isbn,issued_emp_id
)VALUES (p_issued_id , p_member_id, CURRENT_DATE,book_id , p_issued_emp_id );

	UPDATE books
    SET status = 'no'
    WHERE isbn =book_id;

	ELSE
        RAISE NOTICE 'Sorry to inform you the book you have requested is unavailable book_isbn: %', p_issued_book_isbn;
    END IF;
END;
$$;
-- Calling the procedure 
CALL issue_book('IS141','C118', 'E105','978-0-553-29698-2')


--Which authors have the highest cumulative number of book issues?
SELECT b.author, COUNT(i.issued_id) AS total_issues
FROM books as b 
JOIN issued_status as i 
ON b.isbn = i.issued_book_isbn
GROUP BY 1
ORDER BY 2 DESC

--Who are most frequent borrowers every month?
WITH t1 AS (
SELECT DATE_TRUNC('month', i.issued_date)::DATE AS month,m.member_name,COUNT(i.issued_id) as Num_of_books,
 RANK() OVER (PARTITION BY DATE_TRUNC('month', i.issued_date)
            ORDER BY COUNT(i.issued_id) DESC
        ) AS rank
FROM issued_status as i 
JOIN members as m 
ON m.member_id = i.issued_member_id
GROUP BY  DATE_TRUNC('month', i.issued_date),2)

SELECT month,member_name,Num_of_books FROM t1 WHERE rank=1

--What are the peak months for book issues and returns?
SELECT DATE_PART('month', i.issued_date) as month_num,COUNT(i.issued_id) as Num_of_issued_books ,
COUNT(r.return_id) as Num_of_returned_books
FROM issued_status as i 
LEFT JOIN return_status as r 
ON i.issued_id = r.issued_id
GROUP BY 1
ORDER BY 1,2,3 










