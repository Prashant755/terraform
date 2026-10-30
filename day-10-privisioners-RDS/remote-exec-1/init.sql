
USE dev;

CREATE TABLE IF NOT EXISTS departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL UNIQUE,
    location VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    salary DECIMAL(10, 2),
    department_id INT,
    joining_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
);

CREATE TABLE IF NOT EXISTS projects (
    project_id INT AUTO_INCREMENT PRIMARY KEY,
    project_name VARCHAR(100) NOT NULL,
    budget DECIMAL(12, 2),
    employee_id INT,
    start_date DATE,
    FOREIGN KEY (employee_id)
        REFERENCES employees(employee_id)
);

INSERT IGNORE INTO departments
(department_name, location)
VALUES
('IT', 'Bangalore'),
('HR', 'Delhi'),
('Finance', 'Mumbai');

INSERT IGNORE INTO employees
(name, email, salary, department_id, joining_date)
VALUES
('Rahul', 'rahul@gmail.com', 50000, 1, '2026-01-10'),
('Amit', 'amit@gmail.com', 60000, 2, '2026-02-15'),
('Priya', 'priya@gmail.com', 70000, 3, '2026-03-20');

-- Avoid inserting duplicate projects
INSERT INTO projects
(project_name, budget, employee_id, start_date)
SELECT 'AWS Migration', 150000, 1, '2026-04-01'
WHERE NOT EXISTS (
    SELECT 1 FROM projects
    WHERE project_name = 'AWS Migration'
);

INSERT INTO projects
(project_name, budget, employee_id, start_date)
SELECT 'HR Automation', 80000, 2, '2026-04-10'
WHERE NOT EXISTS (
    SELECT 1 FROM projects
    WHERE project_name = 'HR Automation'
);

INSERT INTO projects
(project_name, budget, employee_id, start_date)
SELECT 'Financial Dashboard', 100000, 3, '2026-04-15'
WHERE NOT EXISTS (
    SELECT 1 FROM projects
    WHERE project_name = 'Financial Dashboard'
);

SHOW TABLES;
