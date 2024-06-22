Delimiter //
Create procedure modify_archive(In sid INT,In new_archive Varchar(100),out state Varchar(100))
BEGIN 
	Declare s INT Default 0;
    Declare a INT;
    Declare Continue Handler for sqlexception set s = 1;
    select count(*) From Student Where Strdent.student_id = sid Into a;
    if a!=1 then
		set state = "Not Found Student";
	else
		update Student set archive = new_archive Where student_id = sid;
        set state = "have finished modifying";
	End if;
End //
Delimiter ;
                 
Delimiter //
Create procedure choose_course(In sid INT,In cid INT,In newTerm Varchar(50),In grades float,out state Varchar(20))
BEGIN 
	Declare s INT Default 0;
    Declare a,b,c INT;
    Declare Continue Handler for sqlexception set s = 1;
    select count(*) From Student Where Strdent.student_id = sid Into a;
    select count(*) From Course Where course.course_id = cid Into b;
    if a!=1 then
		set state = "Error:Not Found Student";
	elseif b!=1 then
		set state = "Error:Not Found course";
	else
		select count(*) From Grade Where student_id = sid and course_id = cid Into c;
        if c = 1 then 
			set state = "Error:already exist";
		else 
			INSERT INTO Grade (student_id,course_id, term, score) VALUES (sid, cid, newTerm,grades);
            update Course set selected_count = selected_count + 1 Where Course_id = cid;
            set state = "Insert completely";
            set s = 1;
        End if;
	End if;
    if s = 0 Then 
		rollback;
	else
		Commit;
	End if;
End //
Delimiter ;

Delimiter //
Create procedure delete_grades(In sid INT,In cid INT,out state Varchar(20))
BEGIN 
	Declare s INT Default 0;
    Declare a,b,c INT;
    Declare Continue Handler for sqlexception set s = 1;
    start transaction;
    select count(*) From Student Where Strdent.student_id = sid Into a;
    select count(*) From Course Where course.course_id = cid Into b;
    if a!=1 then
		set state = "Error:Not Found Student";
	elseif b!=1 then
		set state = "Error:Not Found course";
	else
		select count(*) From Grade Where student_id = sid and course_id = cid Into c;
        if c = 0 then 
			set state = "Error:Grades not Exist";
		else 
			delete From Grade Where student_id = sid and course_id = cid;
            update Course set selected_count = selected_count - 1 Where Course_id = cid;
            set state = "Insert completely";
            set s = 1;
        End if;
	End if;
    if s = 0 Then 
		rollback;
	else
		Commit;
	End if;
End //
Delimiter ;

drop procedure update_award_by_name;
Delimiter //
Create procedure update_award_by_name(In sid INT,In award_name Varchar(100),out state INT)
BEGIN 
	Declare s INT Default 0;
    Declare a,b,c,aid,id INT default 0;
    Declare Continue Handler for sqlexception set s = 1;
    select count(*) From Student Where Student.student_id = sid Into a;
    select count(*) From award Where award.aname = award_name Into b;
    set state = -1;
    start transaction;
    if a!=1 then
		set s = 1;
		set state = a;
	elseif b = 0 then
		select count(*) From award Where award.award_id = id into c;
        while c!=0 do
			set id = id + 1;
            select count(*) From award Where award.award_id = id into c;
		End While;
        set state = 3;
        insert into award(award_id,award_time,aname) Values (id,current_date(),award_name);
		insert into StudentAward(student_id,award_id) Values (sid,id);
        set s = 0;
	else
		SET id = (SELECT award_id FROM award WHERE aname = award_name);
        insert into StudentAward(student_id,award_id) Values (sid,id);
        set s = 0;
        set state = 2;
	end if;
    if s = 1 Then 
		rollback;
	else
		Commit;
	End if;
End //
Delimiter ;

