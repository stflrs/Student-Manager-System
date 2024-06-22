INSERT INTO Class (class_id, grade_year, college) VALUES
(1, 2021, 'Gifted Young'),
(2, 2021, 'Gifted Young'),
(3, 2021, 'Computer Science'),
(4, 2022, 'Gifted Young'),
(5, 2022, 'Computer Science');



INSERT INTO Student (student_id, class_id, major, archive) VALUES
(1, 1, 'Mathematics', '../archive/1.txt'),
(2, 2, 'Physics', '../archive/2.txt'),
(3, 3, 'Chemistry', '../archive/3.txt'),
(4, 4, 'Biology', '../archive/4.txt'),
(5, 5, 'Computer Science', '../archive/5.txt'),
(6, 1, 'Mathematics', '../archive/6.txt'),
(7, 2, 'Physics', '../archive/7.txt'),
(8, 3, 'Chemistry', '../archive/8.txt'),
(9, 4, 'Biology', '../archive/9.txt'),
(10, 5, 'Computer Science', '../archive/10.txt');

INSERT INTO Course (course_id,course_name, teacher, selected_count, cred, major) VALUES
(1,"database"				, 'Dr. Zhang', 0, 3, 'Computer Science'),
(2,"nature language process", 'Prof. Li', 0, 3, 'Computer Science'),
(3,"Comparch" 				,'Dr. Wang', 0, 4, 'Computer Science'),
(4,"AI"						,'Prof. Chen', 0, 4, 'Computer Science');

-- 插入奖项数据到 Award 表
INSERT INTO Award (award_id, award_time, aname) VALUES 
(1, '2023-01-15', 'Excellent Student Award'),
(2, '2023-02-10', 'Top Performer Award'),
(3, '2023-03-05', 'Outstanding Contribution Award'),
(4, '2023-04-20', 'Best Attendance Award'),
(5, '2023-05-30', 'Community Service Award');

-- 插入学生奖项关系数据到 StudentAward 表，均为学号1的学生获奖
INSERT INTO StudentAward (student_id, award_id) VALUES 
(1, 1),
(1, 2),
(1, 3),
(1, 4),
(1, 5);


call choose_course(1, 1, '2024 Spring', 88.5,@a);
call choose_course(1, 2, '2024 Spring', 92.0,@a);
call choose_course(2, 2, '2024 Spring', 85.0,@a);
call choose_course(2, 3, '2024 Spring', 79.5,@a);
call choose_course(2, 4, '2024 Spring', 91.0,@a);
call choose_course(3, 1, '2024 Spring', 87.0,@a);
call choose_course(3, 3, '2024 Spring', 88.0,@a);
call choose_course(4, 2, '2024 Spring', 90.0,@a);
call choose_course(4, 4, '2024 Spring', 89.5,@a);
call choose_course(5, 1, '2024 Spring', 85.5,@a);
call choose_course(5, 4, '2024 Spring', 92.5,@a);

SELECT calGPA(1) AS GPA;
Select score,cred from Grade,Course Where Grade.student_id = 1 And score is Not NULL and Course.course_id = Grade.course_id;
