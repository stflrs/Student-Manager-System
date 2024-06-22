use Lab2;

drop table if exists Grade;
drop table if exists StudentAward;
drop table if exists Award;
drop table if exists studentcourse;
drop table if exists Student;
drop table if exists Class;
drop table if exists Course;
drop table if exists userpeople;
-- 班级表
CREATE TABLE Class (
    class_id INT PRIMARY KEY,
    grade_year INT,
    college VARCHAR(100),
    student_count INT DEFAULT 0
);

-- 学生表
CREATE TABLE Student (
    student_id INT PRIMARY KEY,
    class_id INT,
    FOREIGN KEY(class_id) REFERENCES Class(class_id),
    major VARCHAR(100),
    archive VARCHAR(100)
);

-- 课程表
CREATE TABLE Course (
    course_id INT PRIMARY KEY,
    course_name Varchar(100),
    teacher VARCHAR(100),
    selected_count INT DEFAULT 0,
    cred INT,
    major VARCHAR(100)
);

-- 成绩表
CREATE TABLE Grade (
    student_id INT,
    course_id INT,
    term VARCHAR(50),
    score FLOAT,
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (course_id) REFERENCES Course(course_id)
);

-- 奖项表
CREATE TABLE Award (
    award_id INT PRIMARY KEY,
    award_time DATE,
    aname VARCHAR(100)
);

-- 学生奖项关系表
CREATE TABLE StudentAward (
    student_id INT,
    award_id INT,
    PRIMARY KEY (student_id, award_id),
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (award_id) REFERENCES Award(award_id)
);

Create table Userpeople (
    Uname Varchar(100) primary Key,
    Upassword Varchar(100)
);

select * from Userpeople;
select * from Student;
select * from StudentAward;
select * from Award;
select * from Class;
select * From course;
select * From grade;
call update_award_by_name(11,"haoren",@abc);
select @abc;