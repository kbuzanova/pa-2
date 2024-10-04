create database pa_2
use pa_2

CREATE TABLE Authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    date_of_birth DATE
);

CREATE TABLE Books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100),
    author_id INT,
    genre VARCHAR(50),
    year_published INT,
    FOREIGN KEY (author_id) REFERENCES Authors(author_id)
);

CREATE TABLE Members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    phone_number VARCHAR(15)
);

CREATE TABLE Borrowings (
    borrowing_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT,
    member_id INT,
    borrowed_date DATE,
    due_date DATE,
    return_date DATE,
    FOREIGN KEY (book_id) REFERENCES Books(book_id),
    FOREIGN KEY (member_id) REFERENCES Members(member_id)
);

explain -- analyze
select a.author_id,
	a.first_name as author_first_name,
    a.last_name as author_last_name,
    bo.genre,
    count(b.book_id) as total_borrowed_books
from Borrowings b
join Books bo on b.book_id = bo.book_id
join Authors a on bo.author_id = a.author_id
where bo.genre = 'bank'
group by a.author_id, a.first_name, a.last_name
order by total_borrowed_books desc;


CREATE TABLE Authors1 LIKE Authors;
INSERT INTO Authors1 SELECT * FROM Authors;

CREATE TABLE Books1 LIKE Books;
INSERT INTO Books1 SELECT * FROM Books;

CREATE TABLE Members1 LIKE Members;
INSERT INTO Members1 SELECT * FROM Members;

CREATE TABLE Borrowings1 LIKE Borrowings;
INSERT INTO Borrowings1 SELECT * FROM Borrowings;


create index idx_books_genre on Books1(genre)
-- DROP INDEX idx_books_genre ON Books;

explain -- analyze
with cte as (
    select b1.book_id, b1.member_id, bo1.author_id, bo1.genre
    from Borrowings1 b1
    join Books1 bo1 on b1.book_id = bo1.book_id
    where bo1.genre = 'bank'
)
select a1.author_id,
    a1.first_name as author_first_name,
    a1.last_name as author_last_name,
    cte.genre,
    count(cte.book_id) as total_borrowed_books
from cte
join Authors1 a1 on cte.author_id = a1.author_id
group by a1.author_id, a1.first_name, a1.last_name, cte.genre
order by total_borrowed_books desc;