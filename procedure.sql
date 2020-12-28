DELIMITER //
CREATE OR REPLACE PROCEDURE proAddGrades (valor DECIMAL(4,2), gC int, wH BOOLEAN, dni VARCHAR, grupo VARCHAR,acronimo VARCHAR, anyo INT) 
BEGIN
	SET student_id = (SELECT studentId FROM Students WHERE dni = dni);
	SET subject_id = (SELECT subjectId FROM Subjects WHERE acronym=acronimo)
	IF(subject_id IS NOT NULL) THEN
	SET group_id =(SELECT groupId FROM Groups WHERE name=grupo AND year=anyo AND subjectId = subject_id);
	END IF;
	if (student_id AND group_id  IS NOT NULL) then 
	INSERT INTO Grades (value, gradeCall, withHonours, studentId, groupId) VALUES (valor,gC,wH,student_id,group_id);
	END if;
END;

DELIMITER ;

DELIMITER //

CREATE OR REPLACE PROCEDURE prodayTutorials(dayWeek VARCHAR, dni int)
BEGIN
SET teacher_id =(SELECT teacherId FROM Teachers WHERE dni= dni)

IF (teacher_id IS NOT NULL) THEN

SELECT  Students.firstName,Students.surname,Students.email, Appointments.dateAppointment, Appointments.hourAppointment 
FROM Appointments INNER JOIN Students ON Appointments.studentId = Students.studentId 
WHERE tutorialId IN (SELECT tutorialId FROM Tutorials WHERE day=dayWeek AND teacherId=teacher_id)

END IF;
END;

DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE procAssignSubject(idT INT, idG INT, tL INT)
BEGIN
INSERT INTO teachersGroups(teachingLoad, teacherId,groupId) VALUES (tL, idT, idG);
END; 
DELIMITER ;

DELIMITER //
CREATE OR REPLACE FUNCTION  creditSubject(anyo INT,subject_id INT)
BEGIN

SET idteacher = SELECT TeacherGroups.teacherId  FROM TeacherGroups 
JOIN Teachers ON Teachers.teacherId = TeacherGroups.teacherId 
JOIN Groups ON TeacherGroups.groupId = Groups.groupId 
WHERE TeacherGroups.groupId IN (SELECT groupId FROM Groups WHERE subjectId = subject_id AND YEAR = anyo) 
GROUP BY  TeacherGroups.teacherId 
ORDER BY SUM(TeacherGroups.teachingLoad) 
LIMIT 1;

RETURN idteacher;
END; 
DELIMITER ;


DELIMITER //
CREATE OR REPLACE PROCEDURE  deleteGrades(dni varchar)
BEGIN

 set student_id = select studentId FROM Students WHERE dni=dni;
 DELETE FROM Grades WHERE studentId=student_id;

END; 
DELIMITER ;

DELIMITER //
CREATE OR REPLACE FUNCTION avgGrade (studentId INT) RETURNS DOUBLE
BEGIN
RETURN (SELECT AVG(value)
END // 
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE  deleteGrades(dni varchar)
BEGIN

 DELIMITER //
CREATE OR REPLACE PROCEDURE  deleteGrades(dni varchar)
BEGIN

SELECT Students.firstName, Students.surname,Students.email FROM GroupsStudents 
JOIN Groups  ON GroupsStudents.groupId = Groups.groupId 
JOIN Students ON GroupsStudents.studentId = Students.studentId 
WHERE Groups.subjectId IN (SELECT subjectId FROM Subjects WHERE acronym = 'DP') 
GROUP BY GroupsStudents.groupId;

END; 
DELIMITER ;

DELIMITER //

CREATE OR REPLACE VIEW getGroupsGroupedBy AS

SELECT Groups.name, Groups.activity, Groups.year, Subjects.name, Subjects.acronym FROM TeacherGroups 
JOIN Teachers ON Teachers.teacherId = TeacherGroups.teacherId 
JOIN Groups ON TeacherGroups.groupId = Groups.groupId 
JOIN Subjects ON Groups.subjectId = Subjects.subjectId 
GROUP BY Teachers.TeacherId AND Groups.subjectId;

END; 
DELIMITER ;




DELIMITER //

CREATE OR REPLACE VIEW tutorialTeachers AS



END; 
DELIMITER ;




DELIMITER //

CREATE OR REPLACE VIEW tutorialTeachers AS

SELECT Teachers.firstName AS TeacherName, Teachers.surname AS TeacherSurname,Teachers.email 
AS TeacherEmail, Students.firstName AS StudentFirstName,Students.surname 
AS StudentSurname,Appointments.dateAppointment, Appointments.hourAppointment FROM Appointments  
JOIN Students ON Appointments.studentId = Students.studentId 
JOIN Tutorials ON Appointments.tutorialId = Tutorials.tutorialId
JOIN Teachers ON Tutorials.teacherId = Teachers.teacherId
WHERE dateAppointment > CURRENT_DATE() AND hourAppointment > CURRENT_TIME() GROUP BY Teachers.teacherId

END; 
DELIMITER ;
