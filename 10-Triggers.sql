-- 1. Create the database
CREATE DATABASE school_management;
USE school_management;

-- 2. Create the 'teachers' table
CREATE TABLE teachers (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    subject VARCHAR(50),
    experience INT,
    salary DECIMAL(10, 2)
);

-- 3. Insert 8 rows into the 'teachers' table
INSERT INTO teachers (id, name, subject, experience, salary) VALUES
(1, 'Alice', 'Math', 5, 50000),
(2, 'Bob', 'Physics', 8, 55000),
(3, 'Charlie', 'Chemistry', 12, 60000),
(4, 'David', 'Biology', 3, 45000),
(5, 'Eva', 'History', 9, 52000),
(6, 'Frank', 'Geography', 6, 48000),
(7, 'Grace', 'English', 10, 58000),
(8, 'Hank', 'Computer Science', 7, 62000);

-- 4. Create the 'teacher_log' table
CREATE TABLE teacher_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    teacher_id INT,
    action VARCHAR(50),
    timestamp DATETIME
);

-- 5. Create a BEFORE INSERT trigger to prevent negative salaries
DELIMITER $$
CREATE TRIGGER before_insert_teacher
BEFORE INSERT ON teachers
FOR EACH ROW
BEGIN
    IF NEW.salary < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Salary cannot be negative';
    END IF;
END;
$$
DELIMITER ;

-- 6. Create an AFTER INSERT trigger to log insert actions
DELIMITER $$
CREATE TRIGGER after_insert_teacher
AFTER INSERT ON teachers
FOR EACH ROW
BEGIN
    INSERT INTO teacher_log (teacher_id, action, timestamp)
    VALUES (NEW.id, 'INSERT', NOW());
END;
$$
DELIMITER ;

-- 7. Create a BEFORE DELETE trigger to prevent deleting teachers with experience > 10 years
DELIMITER $$
CREATE TRIGGER before_delete_teacher
BEFORE DELETE ON teachers
FOR EACH ROW
BEGIN
    IF OLD.experience > 10 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot delete teachers with more than 10 years of experience';
    END IF;
END;
$$
DELIMITER ;

-- 8. Create an AFTER DELETE trigger to log delete actions
DELIMITER $$
CREATE TRIGGER after_delete_teacher
AFTER DELETE ON teachers
FOR EACH ROW
BEGIN
    INSERT INTO teacher_log (teacher_id, action, timestamp)
    VALUES (OLD.id, 'DELETE', NOW());
END;
$$
DELIMITER ;