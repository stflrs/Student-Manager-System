drop function calGPA;
Delimiter //
Create function calGPA(sid INT)
Returns FLOAT
READS SQL DATA
BEGIN 
	Declare state INT Default 0;
    Declare cred,num INT default 0;
    Declare score,total_c,total_g FLOAT default 0;
    Declare c_count INT;
    Declare t,gpa FLOAT DEFAULT 0;
    Declare ct Cursor for 
		Select Grade.score,Course.cred from Grade,Course Where Grade.student_id = sid And score is Not NULL and Course.course_id = Grade.course_id; 
    Declare Continue Handler for not found set state = 1;
    open ct;
    Repeat
		Fetch ct into score,cred;
        if state = 0 THEN
			set num = num + 1;
			if score>=95 Then SET t = 4.3;
			elseif score>=90 and score <95 Then set t = 4.0;
            elseif score>=85 and score <90 Then set t = 3.7;
            elseif score>=82 and score <85 Then set t = 3.3;
            elseif score>=78 and score <82 Then set t = 3.0;
            elseif score>=75 and score <78 Then set t = 2.7;
            elseif score>=72 and score <75 Then set t = 2.3;
            elseif score>=68 and score <72 Then set t = 2.0;
			Else Set t = 1;
            end if;
            Set total_g = total_g + t * cred;
            Set total_c = total_c + cred;
		End if;
        Until state = 1
	End Repeat;
    Close ct;
    Set gpa = total_g/total_c;
    Return gpa;
End //
Delimiter ;
                 