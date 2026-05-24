DROP DATABASE IF EXISTS airport_management;

CREATE DATABASE airport_management;

USE airport_management;

CREATE TABLE Plane_Models (
    model_id INT PRIMARY KEY AUTO_INCREMENT,
    model_name VARCHAR(100) NOT NULL,
    manufacturer VARCHAR(100),
    engine_type VARCHAR(50)
);

CREATE TABLE Planes (
    plane_id INT PRIMARY KEY AUTO_INCREMENT,
    plane_no VARCHAR(20) UNIQUE,
    model_id INT,
    capacity INT,
    manufacture_year YEAR,
    status VARCHAR(50),

    FOREIGN KEY (model_id)
    REFERENCES Plane_Models(model_id)
);

CREATE TABLE Hangars (
    hangar_id INT PRIMARY KEY AUTO_INCREMENT,
    hangar_name VARCHAR(50),
    location VARCHAR(100),
    capacity INT
);

CREATE TABLE Hangar_Usage (
    usage_id INT PRIMARY KEY AUTO_INCREMENT,
    plane_id INT,
    hangar_id INT,
    entry_date DATETIME,
    exit_date DATETIME,

    FOREIGN KEY (plane_id)
    REFERENCES Planes(plane_id),

    FOREIGN KEY (hangar_id)
    REFERENCES Hangars(hangar_id)
);

CREATE TABLE Employees (
    ssn VARCHAR(20) PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    phone VARCHAR(20),
    salary DECIMAL(10,2),
    union_membership_no VARCHAR(50)
);

CREATE TABLE Technicians (
    technician_id INT PRIMARY KEY AUTO_INCREMENT,
    ssn VARCHAR(20),
    specialization_level VARCHAR(50),

    FOREIGN KEY (ssn)
    REFERENCES Employees(ssn)
);

CREATE TABLE Traffic_Controllers (
    controller_id INT PRIMARY KEY AUTO_INCREMENT,
    ssn VARCHAR(20),
    controller_name VARCHAR(100),
    last_medical_exam DATE,

    FOREIGN KEY (ssn)
    REFERENCES Employees(ssn)
);

CREATE TABLE Technician_Expertise (
    technician_id INT,
    model_id INT,

    PRIMARY KEY (technician_id, model_id),

    FOREIGN KEY (technician_id)
    REFERENCES Technicians(technician_id),

    FOREIGN KEY (model_id)
    REFERENCES Plane_Models(model_id)
);

CREATE TABLE Tests (
    test_id INT PRIMARY KEY AUTO_INCREMENT,
    test_name VARCHAR(100),
    max_score INT,
    duration_hours INT
);

CREATE TABLE Test_Events (
    event_id INT PRIMARY KEY AUTO_INCREMENT,
    plane_id INT,
    technician_id INT,
    test_id INT,
    test_date DATE,
    hours_spent DECIMAL(5,2),
    score INT,

    FOREIGN KEY (plane_id)
    REFERENCES Planes(plane_id),

    FOREIGN KEY (technician_id)
    REFERENCES Technicians(technician_id),

    FOREIGN KEY (test_id)
    REFERENCES Tests(test_id)
);

INSERT INTO Plane_Models
(model_name, manufacturer, engine_type)
VALUES
('Boeing 737', 'AJet', 'Jet'),
('Airbus A320', 'Pegasus', 'Jet'),
('Boeing 777', 'Turkish Airlines', 'Jet');

INSERT INTO Planes
(plane_no, model_id, capacity, manufacture_year, status)
VALUES
('AJT1001', 1, 180, 2018, 'Active'),
('PGS2001', 2, 220, 2020, 'Maintenance'),
('THY3001', 3, 350, 2022, 'Active');

INSERT INTO Hangars
(hangar_name, location, capacity)
VALUES
('Hangar A', 'North Zone', 5),
('Hangar B', 'South Zone', 8),
('Hangar C', 'East Zone', 4);

INSERT INTO Hangar_Usage
(plane_id, hangar_id, entry_date, exit_date)
VALUES
(1,1,'2026-05-20 08:00:00','2026-05-20 18:00:00'),
(2,2,'2026-05-21 09:30:00','2026-05-21 15:00:00'),
(3,3,'2026-05-22 07:00:00','2026-05-22 16:00:00');

INSERT INTO Employees
(ssn, first_name, last_name, phone, salary, union_membership_no)
VALUES
('111111111', 'Ahmet', 'Yılmaz', '05551111111', 45000, 'UNION101'),
('222222222', 'Mehmet', 'Demir', '05552222222', 47000, 'UNION102'),
('333333333', 'Ayşe', 'Kaya', '05553333333', 50000, 'UNION103'),
('444444444', 'Fatma', 'Çelik', '05554444444', 52000, 'UNION104'),
('555555555', 'Ali', 'Şahin', '05555555555', 60000, 'UNION105');

INSERT INTO Technicians
(ssn, specialization_level)
VALUES
('111111111', 'Senior'),
('222222222', 'Expert');

INSERT INTO Traffic_Controllers
(ssn, controller_name, last_medical_exam)
VALUES
('444444444', 'Fatma Çelik', '2026-01-15'),
('555555555', 'Ali Şahin', '2026-02-20');

INSERT INTO Technician_Expertise
(technician_id, model_id)
VALUES
(1,1),
(1,2),
(2,3);

INSERT INTO Tests
(test_name, max_score, duration_hours)
VALUES
('Engine Test', 100, 3),
('Safety Test', 100, 2),
('Electrical Test', 100, 4);

INSERT INTO Test_Events
(plane_id, technician_id, test_id, test_date, hours_spent, score)
VALUES
(1, 1, 1, '2026-05-20', 2.5, 90),
(2, 2, 2, '2026-05-21', 1.5, 75),
(3, 1, 3, '2026-05-22', 3.0, 95);

SELECT * FROM Planes;

SELECT * FROM Employees;

SELECT * FROM Tests;

SELECT * FROM Test_Events;

SELECT MAX(score) AS highest_score
FROM Test_Events;

SELECT AVG(score) AS average_score
FROM Test_Events;

SELECT technician_id, COUNT(*) AS total_tests
FROM Test_Events
GROUP BY technician_id;

SELECT *
FROM Planes
WHERE capacity = (SELECT MAX(capacity) 
FROM Planes);

SELECT *
FROM Planes
WHERE status = 'Maintenance';

SELECT *
FROM Test_Events
WHERE score > 80;

SELECT AVG(salary) AS average_salary
FROM Employees;

SELECT *
FROM Employees
WHERE salary = (SELECT MAX(salary) 
FROM Employees);

SELECT 
Planes.plane_no,
Tests.test_name,
Test_Events.score
FROM Test_Events
JOIN Planes
ON Test_Events.plane_id = Planes.plane_id
JOIN Tests
ON Test_Events.test_id = Tests.test_id;

SELECT specialization_level, COUNT(*) AS total
FROM Technicians
GROUP BY specialization_level;

SELECT *
FROM Test_Events
WHERE YEAR(test_date) = 2026;

SELECT *
FROM Hangars
WHERE capacity > 5;

SELECT SUM(hours_spent) AS total_hours
FROM Test_Events;

SELECT plane_id, AVG(score) AS average_score
FROM Test_Events
GROUP BY plane_id
ORDER BY average_score DESC;

SELECT 
Planes.plane_no,
Hangars.hangar_name,
Hangar_Usage.entry_date,
Hangar_Usage.exit_date
FROM Hangar_Usage
JOIN Planes
ON Hangar_Usage.plane_id = Planes.plane_id
JOIN Hangars
ON Hangar_Usage.hangar_id = Hangars.hangar_id;

SELECT 
Employees.first_name,
Employees.last_name,
Plane_Models.model_name
FROM Technician_Expertise
JOIN Technicians
ON Technician_Expertise.technician_id = Technicians.technician_id
JOIN Employees
ON Technicians.ssn = Employees.ssn
JOIN Plane_Models
ON Technician_Expertise.model_id = Plane_Models.model_id;

SELECT * 
FROM Traffic_Controllers
WHERE last_medical_exam > '2026-01-01';

SELECT first_name, last_name, phone 
FROM Employees 
WHERE ssn IN (SELECT ssn FROM Technicians);