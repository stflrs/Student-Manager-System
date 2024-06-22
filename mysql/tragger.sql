Delimiter //	
CREATE TRIGGER update_class_student_count_insert AFTER INSERT ON Student
FOR EACH ROW
BEGIN
    UPDATE Class SET student_count = student_count + 1 WHERE class_id = NEW.class_id;
END; // 
Delimiter ;


Delimiter //	
CREATE TRIGGER update_class_student_count_delete AFTER DELETE ON Student
FOR EACH ROW
BEGIN
    UPDATE Class SET student_count = student_count - 1 WHERE class_id = OLD.class_id;
END; // 
Delimiter ;
