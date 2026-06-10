-- ============================================================
-- UNIVERSITY COURSE MANAGEMENT SYSTEM
-- Final Project - Complete SQL Script
-- ============================================================

-- ============================================================
-- SECTION 1: CREATE DATABASE & TABLES
-- ============================================================

CREATE DATABASE IF NOT EXISTS UniversityCMS;
USE UniversityCMS;

-- 1. Students Table
CREATE TABLE Students (
    StudentID    INT PRIMARY KEY AUTO_INCREMENT,
    FirstName    VARCHAR(50)  NOT NULL,
    LastName     VARCHAR(50)  NOT NULL,
    Email        VARCHAR(100) UNIQUE NOT NULL,
    BirthDate    DATE,
    EnrollmentDate DATE
);

-- 2. Departments Table
CREATE TABLE Departments (
    DepartmentID   INT PRIMARY KEY AUTO_INCREMENT,
    DepartmentName VARCHAR(100) NOT NULL
);

-- 3. Courses Table
CREATE TABLE Courses (
    CourseID     INT PRIMARY KEY AUTO_INCREMENT,
    CourseName   VARCHAR(100) NOT NULL,
    DepartmentID INT,
    Credits      INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- 4. Instructors Table
-- NOTE: A Salary column is added (required for Query 8)
CREATE TABLE Instructors (
    InstructorID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName    VARCHAR(50)  NOT NULL,
    LastName     VARCHAR(50)  NOT NULL,
    Email        VARCHAR(100) UNIQUE NOT NULL,
    DepartmentID INT,
    Salary       DECIMAL(10,2),
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- 5. Enrollments Table
CREATE TABLE Enrollments (
    EnrollmentID   INT PRIMARY KEY AUTO_INCREMENT,
    StudentID      INT,
    CourseID       INT,
    EnrollmentDate DATE,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID)  REFERENCES Courses(CourseID)
);


-- ============================================================
-- SECTION 2: INSERT SAMPLE DATA (CREATE in CRUD)
-- ============================================================

INSERT INTO Departments (DepartmentName) VALUES
('Computer Science'),
('Mathematics'),
('Physics'),
('English');

INSERT INTO Students (FirstName, LastName, Email, BirthDate, EnrollmentDate) VALUES
('John',  'Doe',     'john.doe@email.com',    '2000-01-15', '2022-08-01'),
('Jane',  'Smith',   'jane.smith@email.com',  '1999-05-25', '2021-08-01'),
('Alice', 'Brown',   'alice.b@email.com',     '2001-03-10', '2023-08-01'),
('Bob',   'Wilson',  'bob.w@email.com',       '2000-07-20', '2019-08-01'),
('Carol', 'Davis',   'carol.d@email.com',     '2002-11-05', '2023-01-15'),
('David', 'Miller',  'david.m@email.com',     '1998-09-12', '2018-08-01'),
('Eva',   'Taylor',  'eva.t@email.com',       '2001-04-18', '2022-01-10'),
('Frank', 'Anderson','frank.a@email.com',     '1999-12-30', '2020-08-01'),
('Grace', 'Thomas',  'grace.t@email.com',     '2003-06-22', '2024-08-01'),
('Hank',  'Jackson', 'hank.j@email.com',      '2000-02-14', '2022-09-01');

INSERT INTO Courses (CourseName, DepartmentID, Credits) VALUES
('Introduction to SQL',   1, 3),
('Data Structures',       2, 4),
('Calculus I',            2, 3),
('Linear Algebra',        2, 3),
('Algebra Basics',        2, 2),
('Statistics',            2, 3),
('Physics 101',           3, 3),
('Operating Systems',     1, 4),
('Database Management',   1, 3),
('English Literature',    4, 2);

INSERT INTO Instructors (FirstName, LastName, Email, DepartmentID, Salary) VALUES
('Alice',   'Johnson', 'alice.johnson@univ.com', 1, 75000.00),
('Bob',     'Lee',     'bob.lee@univ.com',       2, 68000.00),
('Charlie', 'Wang',    'charlie.w@univ.com',     1, 82000.00),
('Diana',   'Patel',   'diana.p@univ.com',       1, 91000.00),
('Edward',  'Kim',     'edward.k@univ.com',      3, 63000.00);

INSERT INTO Enrollments (StudentID, CourseID, EnrollmentDate) VALUES
(1,  1,  '2022-08-01'), (1,  2,  '2022-08-01'),
(2,  2,  '2021-08-01'), (2,  1,  '2021-08-01'),
(3,  1,  '2023-08-01'), (3,  3,  '2023-08-01'),
(4,  1,  '2019-08-01'), (4,  2,  '2019-08-01'),
(5,  1,  '2023-01-15'), (5,  4,  '2023-01-15'),
(6,  2,  '2018-08-01'), (6,  5,  '2018-08-01'),
(7,  1,  '2022-01-10'), (7,  6,  '2022-01-10'),
(8,  2,  '2020-08-01'), (8,  7,  '2020-08-01'),
(9,  1,  '2024-08-01'), (9,  8,  '2024-08-01'),
(10, 1,  '2022-09-01'), (10, 2,  '2022-09-01');


-- ============================================================
-- SECTION 3: CRUD OPERATIONS (Query 1)
-- ============================================================

-- READ
SELECT * FROM Students;
SELECT * FROM Courses;
SELECT * FROM Instructors;
SELECT * FROM Enrollments;
SELECT * FROM Departments;

-- UPDATE
UPDATE Students
SET Email = 'john.doe.updated@email.com'
WHERE StudentID = 1;

UPDATE Courses
SET Credits = 4
WHERE CourseName = 'Introduction to SQL';

-- DELETE (soft example — removes a test record)
DELETE FROM Students WHERE StudentID = 10;

-- Re-insert after delete to keep data intact
INSERT INTO Students (StudentID, FirstName, LastName, Email, BirthDate, EnrollmentDate)
VALUES (10, 'Hank', 'Jackson', 'hank.j@email.com', '2000-02-14', '2022-09-01');

-- Restore original email
UPDATE Students
SET Email = 'john.doe@email.com'
WHERE StudentID = 1;

-- Restore original credits
UPDATE Courses
SET Credits = 3
WHERE CourseName = 'Introduction to SQL';


-- ============================================================
-- SECTION 4: SELECT QUERIES (Queries 2–16)
-- ============================================================

-- Query 2: Students who enrolled after 2022
SELECT StudentID, FirstName, LastName, EnrollmentDate
FROM Students
WHERE YEAR(EnrollmentDate) > 2022;

-- Query 3: Courses by Mathematics dept, limit 5
SELECT c.CourseID, c.CourseName, c.Credits
FROM Courses c
JOIN Departments d ON c.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'Mathematics'
LIMIT 5;

-- Query 4: Students per course, only courses with more than 5 students
SELECT c.CourseName, COUNT(e.StudentID) AS StudentCount
FROM Enrollments e
JOIN Courses c ON e.CourseID = c.CourseID
GROUP BY c.CourseName
HAVING COUNT(e.StudentID) > 5;

-- Query 5: Students enrolled in BOTH Introduction to SQL AND Data Structures
SELECT s.StudentID, s.FirstName, s.LastName
FROM Students s
WHERE s.StudentID IN (
    SELECT e.StudentID FROM Enrollments e
    JOIN Courses c ON e.CourseID = c.CourseID
    WHERE c.CourseName = 'Introduction to SQL'
)
AND s.StudentID IN (
    SELECT e.StudentID FROM Enrollments e
    JOIN Courses c ON e.CourseID = c.CourseID
    WHERE c.CourseName = 'Data Structures'
);

-- Query 6: Students enrolled in EITHER Introduction to SQL OR Data Structures
SELECT DISTINCT s.StudentID, s.FirstName, s.LastName
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
JOIN Courses c ON e.CourseID = c.CourseID
WHERE c.CourseName IN ('Introduction to SQL', 'Data Structures');

-- Query 7: Average number of credits across all courses
SELECT ROUND(AVG(Credits), 2) AS AverageCredits
FROM Courses;

-- Query 8: Maximum salary of instructors in Computer Science
-- ASSUMPTION: Salary column added to Instructors table
SELECT MAX(i.Salary) AS MaxSalary
FROM Instructors i
JOIN Departments d ON i.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'Computer Science';

-- Query 9: Count of students enrolled in each department
SELECT d.DepartmentName, COUNT(DISTINCT s.StudentID) AS StudentCount
FROM Students s
JOIN Enrollments e  ON s.StudentID  = e.StudentID
JOIN Courses c      ON e.CourseID   = c.CourseID
JOIN Departments d  ON c.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentName;

-- Query 10: INNER JOIN — students with their enrolled courses
SELECT s.FirstName, s.LastName, c.CourseName
FROM Students s
INNER JOIN Enrollments e ON s.StudentID = e.StudentID
INNER JOIN Courses c     ON e.CourseID  = c.CourseID;

-- Query 11: LEFT JOIN — all students and their courses (NULL if not enrolled)
SELECT s.FirstName, s.LastName, c.CourseName
FROM Students s
LEFT JOIN Enrollments e ON s.StudentID = e.StudentID
LEFT JOIN Courses c     ON e.CourseID  = c.CourseID;

-- Query 12: Subquery — students enrolled in courses with more than 10 students
SELECT DISTINCT s.StudentID, s.FirstName, s.LastName
FROM Students s
WHERE s.StudentID IN (
    SELECT e.StudentID
    FROM Enrollments e
    WHERE e.CourseID IN (
        SELECT CourseID
        FROM Enrollments
        GROUP BY CourseID
        HAVING COUNT(StudentID) > 10
    )
);

-- Query 13: Extract year from EnrollmentDate of students
SELECT StudentID, FirstName, LastName,
       EnrollmentDate,
       YEAR(EnrollmentDate) AS EnrollmentYear
FROM Students;

-- Query 14: Concatenate instructor first and last name
SELECT InstructorID,
       CONCAT(FirstName, ' ', LastName) AS FullName,
       Email
FROM Instructors;

-- Query 15: Running total of students enrolled in courses (by EnrollmentDate)
SELECT
    e.EnrollmentID,
    s.FirstName,
    s.LastName,
    c.CourseName,
    e.EnrollmentDate,
    SUM(1) OVER (ORDER BY e.EnrollmentDate
                 ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
                ) AS RunningTotal
FROM Enrollments e
JOIN Students s ON e.StudentID = e.StudentID
JOIN Courses  c ON e.CourseID  = c.CourseID
ORDER BY e.EnrollmentDate;

-- Query 16: Label students as 'Senior' or 'Junior'
-- Senior = enrolled more than 4 years ago from today's date
SELECT
    StudentID,
    FirstName,
    LastName,
    EnrollmentDate,
    CASE
        WHEN DATEDIFF(CURDATE(), EnrollmentDate) > (4 * 365)
        THEN 'Senior'
        ELSE 'Junior'
    END AS StudentLabel
FROM Students;