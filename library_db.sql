-- Library Management System Database
-- Created by [Your Name] on [Date]

-- Create database
CREATE DATABASE IF NOT EXISTS library_management;
USE library_management;

-- Members table
CREATE TABLE members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    join_date DATE NOT NULL,
    membership_status ENUM('Active', 'Expired', 'Suspended') DEFAULT 'Active',
    CONSTRAINT chk_email CHECK (email LIKE '%@%.%')
);

-- Books table
CREATE TABLE books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    isbn VARCHAR(20) UNIQUE NOT NULL,
    title VARCHAR(200) NOT NULL,
    author VARCHAR(100) NOT NULL,
    publisher VARCHAR(100),
    publication_year YEAR,
    genre VARCHAR(50),
    total_copies INT NOT NULL DEFAULT 1,
    available_copies INT NOT NULL DEFAULT 1,
    CONSTRAINT chk_copies CHECK (available_copies <= total_copies)
);

-- Book loans table (1-M relationship)
CREATE TABLE book_loans (
    loan_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    loan_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE,
    status ENUM('On Loan', 'Returned', 'Overdue') DEFAULT 'On Loan',
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE,
    CONSTRAINT chk_dates CHECK (due_date > loan_date)
);

-- Fines table (1-1 relationship with loans)
CREATE TABLE fines (
    fine_id INT AUTO_INCREMENT PRIMARY KEY,
    loan_id INT UNIQUE NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    issued_date DATE NOT NULL,
    paid_date DATE,
    status ENUM('Pending', 'Paid') DEFAULT 'Pending',
    FOREIGN KEY (loan_id) REFERENCES book_loans(loan_id) ON DELETE CASCADE
);

-- Authors table (M-M relationship with books)
CREATE TABLE authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    author_name VARCHAR(100) NOT NULL,
    biography TEXT
);

-- Book-Author junction table (M-M relationship)
CREATE TABLE book_authors (
    book_id INT NOT NULL,
    author_id INT NOT NULL,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (author_id) REFERENCES authors(author_id) ON DELETE CASCADE
);

-- Create indexes for performance
CREATE INDEX idx_books_title ON books(title);
CREATE INDEX idx_members_name ON members(last_name, first_name);
CREATE INDEX idx_loans_dates ON book_loans(due_date, return_date);
