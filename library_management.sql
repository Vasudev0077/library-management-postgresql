CREATE OR REPLACE FUNCTION calculate_fine()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    days_late INT;
BEGIN
    IF NEW.return_date IS NOT NULL 
       AND NEW.return_date > NEW.due_date
       AND NOT EXISTS (SELECT 1 FROM fines WHERE issue_id = NEW.issue_id)
    THEN
        days_late := NEW.return_date - NEW.due_date;

        INSERT INTO fines (issue_id, fine_amount)
        VALUES (NEW.issue_id, days_late * 5);
    END IF;

    RETURN NEW;
END;
$$;


CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE roles (
    role_id SERIAL PRIMARY KEY,
    role_name VARCHAR(30) UNIQUE NOT NULL
);

CREATE TABLE books (
    b_id SERIAL PRIMARY KEY,
    b_name VARCHAR(100) NOT NULL,
    b_qty INT NOT NULL CHECK (b_qty >= 0)
);


CREATE TABLE issued_books (
    issue_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(user_id),
    b_id INT NOT NULL REFERENCES books(b_id),
    issue_date DATE NOT NULL DEFAULT CURRENT_DATE,
    due_date DATE NOT NULL DEFAULT CURRENT_DATE + INTERVAL '15 days',
    return_date DATE
);

CREATE TABLE fines (
    fine_id SERIAL PRIMARY KEY,
    issue_id INT UNIQUE REFERENCES issued_books(issue_id) ON DELETE CASCADE,
    fine_amount INT DEFAULT 0 CHECK (fine_amount >= 0),
    paid BOOLEAN DEFAULT FALSE
);

CREATE TABLE accounts (
    account_id SERIAL PRIMARY KEY,
    user_id INT UNIQUE NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    login_uid VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL
);

CREATE TABLE user_roles (
    user_id INT REFERENCES users(user_id) ON DELETE CASCADE,
    role_id INT REFERENCES roles(role_id) ON DELETE CASCADE,
    PRIMARY KEY(user_id, role_id)
);


CREATE INDEX idx_issued_books_user ON issued_books(user_id);
CREATE INDEX idx_issued_books_book ON issued_books(b_id);
CREATE INDEX idx_fines_issue ON fines(issue_id);


CREATE TRIGGER trg_calculate_fine
AFTER UPDATE OF return_date ON issued_books
FOR EACH ROW
EXECUTE FUNCTION calculate_fine();

--Sample Data--

-- Roles
INSERT INTO roles(role_name) VALUES
('Admin'),
('Student'),
('Librarian');

-- Users
INSERT INTO users(full_name, email) VALUES
('Amit Sharma', 'amit@example.com'),
('Priya Verma', 'priya@example.com'),
('Rahul Singh', 'rahul@example.com'),
('Admin User', 'admin@example.com');

-- Books
INSERT INTO books(b_name, b_qty) VALUES
('Database System Concepts', 5),
('Operating System Concepts', 4),
('Computer Networks', 6),
('Clean Code', 3),
('Data Structures in C', 7);

-- Accounts
INSERT INTO accounts(user_id, login_uid, password_hash) VALUES
(1, 'amit01', 'hashed_pw_1'),
(2, 'priya01', 'hashed_pw_2'),
(3, 'rahul01', 'hashed_pw_3'),
(4, 'admin01', 'hashed_pw_4');

-- User Roles
INSERT INTO user_roles(user_id, role_id) VALUES
(1, 2),
(2, 2),
(3, 3),
(4, 1);

-- Issued Books
INSERT INTO issued_books(user_id, b_id, issue_date, due_date, return_date) VALUES
(1, 1, '2026-05-01', '2026-05-15', '2026-05-18'),
(2, 3, '2026-05-05', '2026-05-20', NULL),
(1, 4, '2026-05-12', '2026-05-25', '2026-05-28');