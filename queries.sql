INSERT INTO Degrees (name, years) VALUES
	('DegreesIngeniería del Software', 4),
	('Ingeniería del Computadores', 4),
	('Tecnologías Informáticas', 4);

INSERT INTO Subjects (name, acronym, credits, year, type, degreeId) VALUES
	('Fundamentos de Programación', 'FP', 12, 1, 'Formacion Basica', 3),
	('Lógica Informatica', 'LI', 6, 2, 'Optativa', 3);
	
INSERT INTO Groups (name, activity, year, subjectId) VALUES
	('T1', 'Teoria', 2019, 1),
	('L1', 'Laboratorio', 2019, 1),
	('L2', 'Laboratorio', 2019, 1);
	
INSERT INTO Students (accessMethod, dni, firstname, surname, birthdate, email) VALUES
	('Selectividad', '12345678A', 'Daniel', 'Pérez', '1991-01-01', 'daniel@alum.us.es'),
	('Selectividad', '22345678A', 'Rafael', 'Ramírez', '1992-01-01', 'rafael@alum.us.es'),
	('Selectividad', '32345678A', 'Gabriel', 'Hernández', '1993-01-01', 'gabriel@alum.us.es');
	
INSERT INTO GroupsStudents (groupId, studentId) VALUES
	(1, 1),
	(3, 1);
	
INSERT INTO Grades (value, gradeCall, withHonours, studentId, groupId) VALUES
	(4.50, 1, 0, 1, 1);
	
UPDATE Students 
	SET birthdate = '1998-01-01', surname='Fernández' 
	WHERE studentId = 3;
	
UPDATE Subjects
	SET credits = credits/2;
	
DELETE FROM Grades
	WHERE gradeId = 1;
	
DELETE FROM Groups
	WHERE activity = 'Laboratorio';
	
SELECT * 
	FROM Students, Groups
	WHERE accessMethod = 'Selectividad';
	
SELECT credits > 3
	FROM Subjects;
	
SELECT AVG(credits)
	FROM Subjects;
	
SELECT COUNT(*)
	FROM Subjects
	WHERE credits > 4;
		
SELECT COUNT(DISTINCT accessMethod)
	FROM Students;
	

-- SELECT diversos
--Todas las asignaturas
SELECT * 
	FROM Subjects;

--Asignatura con acronimo FP
SELECT * 
	FROM Subjects 
	WHERE acronym='FP';

--Nombres y acrónimos de todas las asignaturas
SELECT name, acronym 
	FROM Subjects;

--Media de las notas del grupo de id 18
SELECT AVG(VALUE) 
	FROM Grades 
	WHERE groupId=18;

--Total de créditos de las asignaturas del grado de tecnologías informáticas (degreeId 3)
SELECT SUM(credits) 
	FROM Subjects 
	WHERE degreeId=3;

--Notas con valor menor que 4 o mayor que 6
SELECT * 
	FROM Grades 
	WHERE value < 4 OR value > 6;

--Nombres de grupos diferentes
SELECT DISTINCT NAME 
	FROM Groups;

--Máxima nota del alumno de id 1
SELECT MAX(VALUE) 
	FROM Grades 
	WHERE studentId=1;

--Alumnos con un apellido igual al acrónimo de alguna asignatura
SELECT * 
	FROM Students 
	WHERE surname IN (SELECT acronym FROM Subjects);

-- IDs de alumnos del curso 2019	
SELECT DISTINCT(StudentId) 
	FROM GroupsStudents 
	WHERE groupId IN (SELECT groupId FROM Groups WHERE year = 2019);
	
-- Alumnos con un DNI terminado en la letra C
SELECT *
	FROM Students
	WHERE dni LIKE('%C')

-- Alumnos con un nombre de 6 letras
SELECT *
	FROM Students
	WHERE firstName LIKE('______') -- 6 guiones bajos

-- Alumnos nacidos antes de 1995
SELECT *
	FROM Students
	WHERE YEAR(birthdate) < 1995
	
-- ALumnos nacidos entre enero y febrero
SELECT *
	FROM Students 
	WHERE (MONTH(birthdate) >= 1 AND MONTH(birthdate) <= 2)

-- Vistas
CREATE OR REPLACE VIEW ViewGradesGroup18 AS
	SELECT * FROM Grades WHERE groupId = 18;

SELECT MAX(value) FROM ViewGradesGroup18;
SELECT COUNT(*) FROM ViewGradesGroup18;
SELECT * FROM ViewGradesGroup18 WHERE gradeCall = 2;

CREATE OR REPLACE VIEW ViewGradesGroup18Call1 AS
	SELECT * FROM ViewGradesGroup18 WHERE gradeCall = 1;
	
SELECT * FROM ViewGradesGroup18Call1;


--Para casa
--Nombre de las asignaturas obligatorias
SELECT NAME 
	FROM Subjects 
	WHERE type='Obligatoria';

--Media de las notas del grupo de id 19, sin usar AVG
SELECT SUM(value)/COUNT(*) 
	FROM Grades 
	WHERE groupId=18;

--Cantidad de nombres de grupos diferentes
SELECT COUNT(DISTINCT NAME) 
	FROM Groups;

--Notas con valor igual o superior a 9, pero que no son matrícula de honor
SELECT * 
	FROM Grades 
	WHERE value >= 9 AND withHonours=0;

--Notas entre 4 y 6
SELECT * 
	FROM Grades 
	WHERE value >= 4 AND value <= 6;