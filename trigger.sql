--limitecreditos

DELIMITER //
CREATE OR REPLACE TRIGGER triggerTeacherCreditLimit_insert
      BEFORE INSERT ON TeachersGroups
      FOR EACH ROW BEGIN
             DECLARE totalCredits INT;
             DECLARE total INT;
SET totalCredits = (
                   SELECT SUM(credits) FROM TeachersGroups, Groups
                  	WHERE TeachersGroups.groupId = Groups.groupId AND TeachersGroups.teacherId = new.teacherId AND Groups.year = 
(SELECT year FROM Groups WHERE Groups.groupId = new.groupId)
             );
SET total = totalCredits + new.credits; IF (total > 24) THEN
                   SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT =
                          'Un profesor no puede impartir mas de 24 creditospor curso academico';
 END IF;
END //

DELIMITER ;


--matriculadehonor
DELIMITER //
CREATE OR REPLACE TRIGGER triggerWithHonoursInsert BEFORE INSERT ON Grades
FOR EACH ROW
BEGIN
IF (new.withHonours = 1 AND new.value < 9.0) THEN
SIGNAL SQLSTATE '45000' SET message_text =
'Para obtener matrícula hay que sacar al menos un 9';
END IF; END//
CREATE OR REPLACE TRIGGER triggerWithHonoursUpdate BEFORE UPDATE ON Grades
FOR EACH ROW
BEGIN
IF (new.withHonours = 1 AND new.value < 9.0) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT=
'Para obtener matrícula hay que sacar al menos un 9'
END IF;
END//
DELIMITER ;

--notaporalumno
DELIMITER //
CREATE OR REPLACE TRIGGER triggerUniqueGradesSubject
BEFORE INSERT ON Grades FOR EACH ROW
BEGIN
	DECLARE subject INT; -- La asignatura en le nota
	DECLARE groupYear INT; -- El año al que corresponde
	DECLARE subjectGrades INT; -- Conteo de notas de la misma asignatura/alumno/año/convocatoria
SELECT subjectId, year INTO subject, groupYear FROM Groups WHERE groupId=new.groupId;
SET subjectGrades = (SELECT COUNT(*) FROM Grades, Groups WHERE (Grades.studentId = new.studentId AND -- Mismo estudiante
Grades.gradeCall = new.gradeCall AND -- Misma convocatoria
Grades.groupId = Groups.groupId AND Groups.year = groupYear AND -- Mismo año Groups.subjectId = subject)); -- Misma asignatura
IF (subjectGrades > 0) THEN
SIGNAL SQLSTATE '45000' SET message_text =
'Un alumno no puede tener varias notas asociadas a la misma asignatura en la misma convocatoria, el mismo año';
END IF;
 END//
DELIMITER ;


--cambiosbruscoennota
DELIMITER //
CREATE OR REPLACE TRIGGER triggerGradesChangeDifference
BEFORE UPDATE ON Grades FOR EACH ROW
BEGIN
	DECLARE difference DECIMAL (4,2); DECLARE student ROW TYPE OF Students; SET difference = new.value - old.value; 
	IF(difference > 4) THEN
	SELECT * INTO student FROM Students WHERE studentId = new.studentId;
	SET @error_message = CONCAT('Al alumno ', student.firstName, ' ', student.surname,
' se le ha intentado subir una nota en ', difference, ' puntos'); 
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = @error_message;
END IF; 
END//
DELIMITER ;


--alumnoperteneceagrupo

DELIMITER //
CREATE OR REPLACE TRIGGER triggerGradeStudentGroup
BEFORE INSERT ON Grades FOR EACH ROW
BEGIN
	DECLARE isInGroup INT;
	SET isInGroup = (SELECT COUNT(*) FROM GroupsStudents
	WHERE studentId = new.studentId AND groupId = new.groupId);
	IF(isInGroup < 1) THEN
	SIGNAL SQLSTATE '45000' SET message_text ='Un alumno no puede tener notas en grupos a los que no pertenece';
END IF; 
END//
DELIMITER ;