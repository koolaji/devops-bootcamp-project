-- Employee Database for DevOps Assignment
-- Created: 2025-11-06 14:39:06

DROP DATABASE IF EXISTS employee_company;
CREATE DATABASE employee_company;
USE employee_company;

-- Create employees table
CREATE TABLE employees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id VARCHAR(10) UNIQUE NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    department VARCHAR(50) NOT NULL,
    position VARCHAR(100) NOT NULL,
    hire_date DATE NOT NULL,
    salary DECIMAL(10,2) NOT NULL,
    manager_id VARCHAR(10),
    status ENUM('Active', 'Inactive', 'On Leave') DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Insert sample data
INSERT INTO employees (employee_id, first_name, last_name, email, phone, department, position, hire_date, salary, manager_id, status) VALUES

('EMP9579', 'James', 'Wright', 'james.wright@company.com', '+1-283-497-4393', 'Operations', 'Process Analyst', '2020-11-19', 70358, NULL, 'Active'),
('EMP5619', 'Ruth', 'Garcia', 'ruth.garcia@company.com', '+1-816-677-4132', 'Finance', 'Controller', '2024-05-05', 80426, NULL, 'On Leave'),
('EMP8256', 'Emily', 'Harris', 'emily.harris@company.com', '+1-349-982-9425', 'Finance', 'Budget Analyst', '2023-01-29', 87657, NULL, 'Active'),
('EMP1575', 'George', 'Martin', 'george.martin@company.com', '+1-240-468-6662', 'IT Support', 'System Administrator', '2022-07-12', 63178, NULL, 'Active'),
('EMP6668', 'Anthony', 'Baker', 'anthony.baker@company.com', '+1-764-223-8753', 'Marketing', 'SEO Specialist', '2021-03-01', 77372, NULL, 'Active'),
('EMP7433', 'Sharon', 'Campbell', 'sharon.campbell@company.com', '+1-718-736-1689', 'IT Support', 'Network Engineer', '2022-09-25', 78812, 'EMP6668', 'Active'),
('EMP6344', 'Elizabeth', 'Hall', 'elizabeth.hall@company.com', '+1-922-386-9236', 'IT Support', 'Network Engineer', '2022-02-08', 83571, NULL, 'Active'),
('EMP7618', 'Edward', 'Hall', 'edward.hall@company.com', '+1-464-448-2045', 'Operations', 'Process Analyst', '2024-06-17', 54219, NULL, 'Active'),
('EMP6350', 'Donna', 'Miller', 'donna.miller@company.com', '+1-832-940-6712', 'IT Support', 'Help Desk Technician', '2022-02-20', 72989, NULL, 'Active'),
('EMP7737', 'Carol', 'Mitchell', 'carol.mitchell@company.com', '+1-726-361-4103', 'Finance', 'Controller', '2022-01-16', 58238, NULL, 'Active'),
('EMP1600', 'Sarah', 'Taylor', 'sarah.taylor@company.com', '+1-507-344-7112', 'Finance', 'Finance Manager', '2022-09-16', 80157, 'EMP9579', 'Active'),
('EMP7269', 'Andrew', 'Flores', 'andrew.flores@company.com', '+1-976-811-6108', 'Engineering', 'DevOps Engineer', '2025-08-25', 77399, 'EMP1575', 'Active'),
('EMP8225', 'Elizabeth', 'Campbell', 'elizabeth.campbell@company.com', '+1-724-458-4722', 'Marketing', 'SEO Specialist', '2021-04-29', 79407, 'EMP1575', 'Active'),
('EMP3495', 'Barbara', 'Lewis', 'barbara.lewis@company.com', '+1-675-562-1612', 'IT Support', 'System Administrator', '2021-04-30', 80373, 'EMP6344', 'Active'),
('EMP2276', 'Andrew', 'Rivera', 'andrew.rivera@company.com', '+1-764-341-8152', 'Engineering', 'Software Engineer', '2021-02-27', 96910, NULL, 'Active'),
('EMP4458', 'Patricia', 'Moore', 'patricia.moore@company.com', '+1-999-993-6467', 'Operations', 'Operations Manager', '2025-01-01', 82065, 'EMP6668', 'Active'),
('EMP2755', 'Brian', 'Hernandez', 'brian.hernandez@company.com', '+1-254-907-5661', 'Finance', 'Budget Analyst', '2022-01-31', 66111, 'EMP6344', 'Active'),
('EMP7231', 'William', 'Wright', 'william.wright@company.com', '+1-293-238-2915', 'Finance', 'Finance Manager', '2025-04-06', 68750, 'EMP2755', 'Active'),
('EMP8610', 'James', 'King', 'james.king@company.com', '+1-995-535-2752', 'Engineering', 'QA Engineer', '2023-01-31', 72307, 'EMP4458', 'Active'),
('EMP2239', 'Donald', 'Martinez', 'donald.martinez@company.com', '+1-705-773-3541', 'Engineering', 'Senior Developer', '2021-08-12', 62713, NULL, 'Active'),
('EMP2389', 'James', 'Baker', 'james.baker@company.com', '+1-888-261-3049', 'Operations', 'Logistics Coordinator', '2022-09-03', 65193, 'EMP2239', 'Active'),
('EMP4366', 'Jessica', 'Miller', 'jessica.miller@company.com', '+1-523-487-3748', 'IT Support', 'Network Engineer', '2024-05-19', 52173, 'EMP8225', 'Inactive'),
('EMP2628', 'Christopher', 'Wright', 'christopher.wright@company.com', '+1-707-207-2541', 'Finance', 'Accountant', '2022-04-10', 75769, NULL, 'Active'),
('EMP3837', 'Robert', 'Perez', 'robert.perez@company.com', '+1-784-905-8482', 'HR', 'Compensation Analyst', '2020-12-09', 54382, 'EMP7231', 'Inactive'),
('EMP9344', 'Donna', 'Jones', 'donna.jones@company.com', '+1-370-719-1491', 'HR', 'Training Specialist', '2021-06-05', 48796, 'EMP7618', 'Active'),
('EMP8424', 'Sarah', 'Harris', 'sarah.harris@company.com', '+1-457-653-4159', 'Finance', 'Financial Analyst', '2025-01-17', 89795, 'EMP9344', 'Active'),
('EMP2346', 'Elizabeth', 'Nguyen', 'elizabeth.nguyen@company.com', '+1-838-459-6559', 'IT Support', 'Help Desk Technician', '2021-08-08', 69202, NULL, 'Active'),
('EMP6450', 'Robert', 'Green', 'robert.green@company.com', '+1-655-795-1375', 'HR', 'Recruiter', '2021-02-03', 61798, 'EMP2346', 'Active'),
('EMP3692', 'Anthony', 'Harris', 'anthony.harris@company.com', '+1-845-753-5814', 'Marketing', 'Content Writer', '2025-04-03', 48221, NULL, 'Active'),
('EMP3374', 'Kenneth', 'Lopez', 'kenneth.lopez@company.com', '+1-362-674-9477', 'HR', 'HR Manager', '2023-04-07', 59073, 'EMP8424', 'Active'),
('EMP4707', 'Daniel', 'Garcia', 'daniel.garcia@company.com', '+1-611-363-9089', 'Finance', 'Budget Analyst', '2025-05-02', 74055, 'EMP9579', 'Active'),
('EMP1882', 'Susan', 'Jackson', 'susan.jackson@company.com', '+1-440-937-5244', 'Marketing', 'Brand Manager', '2022-06-15', 59584, 'EMP2276', 'Active'),
('EMP3565', 'John', 'Miller', 'john.miller@company.com', '+1-846-302-9358', 'Sales', 'Business Development', '2023-01-07', 68249, 'EMP1600', 'Active'),
('EMP3689', 'Kimberly', 'Thompson', 'kimberly.thompson@company.com', '+1-483-708-9271', 'Operations', 'Operations Manager', '2023-01-22', 78970, 'EMP6450', 'Active'),
('EMP7610', 'Patricia', 'Roberts', 'patricia.roberts@company.com', '+1-624-560-4826', 'HR', 'HR Manager', '2020-11-29', 60229, 'EMP2276', 'Active'),
('EMP4294', 'Kevin', 'Martin', 'kevin.martin@company.com', '+1-386-953-2225', 'IT Support', 'Help Desk Technician', '2023-02-24', 81195, 'EMP7610', 'Inactive'),
('EMP9949', 'Karen', 'Carter', 'karen.carter@company.com', '+1-770-983-8251', 'Finance', 'Controller', '2021-02-21', 87639, 'EMP3692', 'Active'),
('EMP9893', 'Barbara', 'Mitchell', 'barbara.mitchell@company.com', '+1-754-342-5259', 'Engineering', 'DevOps Engineer', '2023-05-16', 96709, 'EMP9949', 'On Leave'),
('EMP9637', 'George', 'Sanchez', 'george.sanchez@company.com', '+1-274-270-6189', 'Operations', 'Operations Specialist', '2023-12-10', 84422, 'EMP7737', 'Inactive'),
('EMP1375', 'David', 'White', 'david.white@company.com', '+1-232-751-6919', 'Operations', 'Supply Chain Analyst', '2021-08-18', 72266, 'EMP3495', 'On Leave'),
('EMP1696', 'Jane', 'Williams', 'jane.williams@company.com', '+1-677-460-3683', 'Operations', 'Process Analyst', '2024-08-24', 74893, 'EMP6350', 'Active'),
('EMP7765', 'Jane', 'Baker', 'jane.baker@company.com', '+1-384-888-8411', 'IT Support', 'Database Administrator', '2024-10-16', 80853, 'EMP7610', 'Active'),
('EMP1478', 'Robert', 'Lewis', 'robert.lewis@company.com', '+1-233-702-3027', 'IT Support', 'Network Engineer', '2021-04-08', 65792, 'EMP4366', 'On Leave'),
('EMP2567', 'Mark', 'Brown', 'mark.brown@company.com', '+1-516-349-1226', 'Operations', 'Logistics Coordinator', '2021-02-07', 70871, NULL, 'Active'),
('EMP6778', 'Edward', 'Harris', 'edward.harris@company.com', '+1-792-761-4758', 'IT Support', 'Database Administrator', '2021-10-12', 55998, 'EMP9579', 'Active'),
('EMP4535', 'Susan', 'Nguyen', 'susan.nguyen@company.com', '+1-603-715-8487', 'Marketing', 'Brand Manager', '2022-05-25', 79254, 'EMP4707', 'Active'),
('EMP8857', 'Carol', 'Johnson', 'carol.johnson@company.com', '+1-482-408-6986', 'Operations', 'Process Analyst', '2025-06-09', 55292, 'EMP6350', 'Active'),
('EMP4199', 'Sandra', 'Martinez', 'sandra.martinez@company.com', '+1-308-367-4149', 'Finance', 'Budget Analyst', '2022-11-09', 80810, 'EMP3692', 'On Leave'),
('EMP6362', 'Joseph', 'Moore', 'joseph.moore@company.com', '+1-330-963-4718', 'Operations', 'Process Analyst', '2022-10-18', 76178, NULL, 'Active'),
('EMP8205', 'Betty', 'Roberts', 'betty.roberts@company.com', '+1-530-935-4953', 'Marketing', 'Content Writer', '2022-09-15', 52458, 'EMP4707', 'Active');

-- Create departments table for reference
CREATE TABLE departments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(50) UNIQUE NOT NULL,
    department_head VARCHAR(10),
    budget DECIMAL(12,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO departments (department_name, department_head, budget) VALUES
('Engineering', 'EMP1001', 2500000.00),
('Marketing', 'EMP1002', 800000.00),
('Sales', 'EMP1003', 1200000.00),
('HR', 'EMP1004', 600000.00),
('Finance', 'EMP1005', 400000.00),
('Operations', 'EMP1006', 1000000.00),
('IT Support', 'EMP1007', 750000.00);

-- Create a view for easy reporting
CREATE VIEW employee_summary AS
SELECT 
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS full_name,
    e.email,
    e.department,
    e.position,
    e.salary,
    e.hire_date,
    e.status,
    DATEDIFF(CURDATE(), e.hire_date) AS days_employed
FROM employees e
ORDER BY e.department, e.last_name;

-- Add some indexes for better performance
CREATE INDEX idx_department ON employees(department);
CREATE INDEX idx_status ON employees(status);
CREATE INDEX idx_hire_date ON employees(hire_date);

-- Show table information
SELECT 'Database created successfully!' as message;
SELECT COUNT(*) as total_employees FROM employees;
SELECT department, COUNT(*) as employee_count FROM employees GROUP BY department ORDER BY employee_count DESC;