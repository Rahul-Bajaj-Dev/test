-- Create Authors Table
CREATE TABLE Authors (
    author_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL
);

-- Create Books Table
CREATE TABLE Books (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    quantity_in_stock INT DEFAULT 0
);

-- Create BookAuthors Table (Many-to-Many Relationship)
CREATE TABLE BookAuthors (
    book_id INT,
    author_id INT,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES Books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (author_id) REFERENCES Authors(author_id) ON DELETE CASCADE
);

-- Insert Sample Authors
INSERT INTO Authors (name) VALUES 
('J.K. Rowling'),
('George R.R. Martin'),
('J.R.R. Tolkien');

-- Insert Sample Books
INSERT INTO Books (title, price, quantity_in_stock) VALUES 
('Harry Potter and the Sorcerer\'s Stone', 20.99, 50),
('A Game of Thrones', 25.50, 30),
('The Hobbit', 15.75, 20),
('Harry Potter and the Chamber of Secrets', 22.99, 40),
('The Lord of the Rings', 30.00, 15);

-- Associate Books with Authors
INSERT INTO BookAuthors (book_id, author_id) VALUES 
(1, 1), (4, 1),  -- J.K. Rowling
(2, 2),          -- George R.R. Martin
(3, 3), (5, 3);  -- J.R.R. Tolkien

-- Retrieve Titles of Books by a Specific Author
SELECT b.title 
FROM Books b
JOIN BookAuthors ba ON b.book_id = ba.book_id
JOIN Authors a ON ba.author_id = a.author_id
WHERE a.name = 'J.K. Rowling';

-- List All Books with Their Authors
SELECT b.title, COALESCE(a.name, 'N/A') AS author_name
FROM Books b
LEFT JOIN BookAuthors ba ON b.book_id = ba.book_id
LEFT JOIN Authors a ON ba.author_id = a.author_id;

-- Update Quantity in Stock After a Sale
UPDATE Books 
SET quantity_in_stock = quantity_in_stock - 5
WHERE title = 'Harry Potter and the Sorcerer\'s Stone';

-- Find the Book with the Highest Quantity in Stock
SELECT title, quantity_in_stock 
FROM Books
ORDER BY quantity_in_stock DESC
LIMIT 1;

-- Remove Books That Are Out of Stock
DELETE FROM Books WHERE quantity_in_stock = 0;

-- Show Average Price of Books for Authors Who Have Written More Than One Book
SELECT a.name AS author_name, AVG(b.price) AS avg_price
FROM Books b
JOIN BookAuthors ba ON b.book_id = ba.book_id
JOIN Authors a ON ba.author_id = a.author_id
GROUP BY a.author_id
HAVING COUNT(b.book_id) > 1;

-- Retrieve the Top 3 Most Expensive Books
SELECT title, price 
FROM Books
ORDER BY price DESC
LIMIT 3;
