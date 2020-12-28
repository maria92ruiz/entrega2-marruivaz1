CREATE DATABASE IF NOT EXISTS ISL4;
USE ISL4;
#DROP TABLE IF EXISTS Grades;
#DROP TABLE IF EXISTS GroupsStudents;
#DROP TABLE IF EXISTS Students;
#DROP TABLE IF EXISTS Groups;
#DROP TABLE IF EXISTS Subjects;
#DROP TABLE IF EXISTS Degrees;
#DROP TABLE IF EXISTS Teachers;
#DROP TABLE IF EXISTS Departments;
#DROP TABLE IF EXISTS Tutorials;
#DROP TABLE IF EXISTS StudentsTutorials;
#DROP TABLE IF EXISTS TeacherGroups;

CREATE TABLE IF NOT EXISTS Degrees(
	degreeId INT NOT NULL AUTO_INCREMENT,
	name VARCHAR(60) NOT NULL UNIQUE,
	years INT DEFAULT(4) NOT NULL,
	PRIMARY KEY (degreeId),
	CONSTRAINT invalidDegreeYear CHECK (years >=3 AND years <=5)
);

CREATE TABLE  IF NOT EXISTS Subjects(
	subjectId INT NOT NULL AUTO_INCREMENT,
	name VARCHAR(100) NOT NULL UNIQUE,
	acronym VARCHAR(8) NOT NULL UNIQUE,
	credits INT NOT NULL,
	year INT NOT NULL,
	type VARCHAR(20) NOT NULL,
	degreeId INT NOT NULL,
	PRIMARY KEY (subjectId),
	FOREIGN KEY (degreeId) REFERENCES Degrees (degreeId),
	CONSTRAINT negativeSubjectCredits CHECK (credits > 0),
	CONSTRAINT invalidSubjectCourse CHECK (year >= 1 AND year <= 5),
	CONSTRAINT invalidSubjectType CHECK (type IN ('Formacion Basica',
																 'Optativa',
																 'Obligatoria'))
);

CREATE TABLE  IF NOT EXISTS Groups(
	groupId INT NOT NULL AUTO_INCREMENT,
	name VARCHAR(30) NOT NULL,
	activity VARCHAR(20) NOT NULL,
	year INT NOT NULL,
	subjectId INT NOT NULL,
	PRIMARY KEY (groupId),
	FOREIGN KEY (subjectId) REFERENCES Subjects (subjectId),
	UNIQUE (name, year, subjectId),
	CONSTRAINT negativeGroupYear CHECK (year > 0),
	CONSTRAINT invalidGroupActivity CHECK (activity IN ('Teoria',
																		 'Laboratorio'))
);

CREATE TABLE  IF NOT EXISTS Students(
	studentId INT NOT NULL AUTO_INCREMENT,
	accessMethod VARCHAR(30) NOT NULL,
	dni VARCHAR(9) NOT NULL UNIQUE,
	firstName VARCHAR(100) NOT NULL,
	surname VARCHAR(100) NOT NULL,
	birthDate DATE NOT NULL,
	email VARCHAR(250) NOT NULL UNIQUE,
	PRIMARY KEY (studentId),
	CONSTRAINT invalidStudentAccessMethod CHECK (accessMethod IN ('Selectividad',
																					  'Ciclo',
																					  'Mayor',
																					  'Titulado Extranjero'))
);

CREATE TABLE  IF NOT EXISTS GroupsStudents(
	groupStudentId INT NOT NULL AUTO_INCREMENT,
	groupId INT NOT NULL,
	studentId INT NOT NULL,
	PRIMARY KEY (groupStudentId),
	FOREIGN KEY (groupId) REFERENCES Groups (groupId),
	FOREIGN KEY (studentId) REFERENCES Students (studentId),
	UNIQUE (groupId, studentId)
);

CREATE TABLE  IF NOT EXISTS Grades(
	gradeId INT NOT NULL AUTO_INCREMENT,
	value DECIMAL(4,2) NOT NULL,
	gradeCall INT NOT NULL,
	withHonours BOOLEAN NOT NULL,
	studentId INT NOT NULL,
	groupId INT NOT NULL,
	PRIMARY KEY (gradeId),
	FOREIGN KEY (studentId) REFERENCES Students (studentId),
	FOREIGN KEY (groupId) REFERENCES Groups (groupId),
	CONSTRAINT invalidGradeValue CHECK (value >= 0 AND value <= 10),
	CONSTRAINT invalidGradeCall CHECK (gradeCall >= 1 AND gradeCall <= 3),
	CONSTRAINT duplicatedCallGrade UNIQUE (gradeCall, studentId, groupId)
);



CREATE TABLE  IF NOT EXISTS Departments(
	departmentId INT NOT NULL AUTO_INCREMENT,
	firstname VARCHAR(256) NOT NULL,
	PRIMARY KEY(departmentId)
);

CREATE TABLE  IF NOT EXISTS Tutorials(
  tutorialId INT NOT NULL AUTO_INCREMENT,
  day VARCHAR(100) NOT NULL,
	initHour TIME NOT NULL,
  endHour TIME NOT NULL,
  teacherId INT,
  PRIMARY KEY(tutorialId),
  CONSTRAINT invalidTutorialsDay CHECK (day IN ('Lunes','Martes','Miercoles','Jueves','Viernes'))
);

CREATE TABLE  IF NOT EXISTS Teachers(
	teacherId INT NOT NULL AUTO_INCREMENT,
	dni CHAR(9) NOT NULL UNIQUE,
	firstName VARCHAR(100) NOT NULL,
	surname VARCHAR(100) NOT NULL,
	birthDate DATE NOT NULL,
	email VARCHAR(250) NOT NULL UNIQUE,
	tutorialId INT NOT NULL,
	departmentId INT NOT NULL,
	PRIMARY KEY (teacherId),
	FOREIGN KEY (tutorialId) REFERENCES Tutorials(tutorialId) ,
	FOREIGN KEY(departmentId) REFERENCES Departments(departmentId)
	
);

CREATE TABLE  IF NOT EXISTS StudentsTutorials(
	studentTutorialId INT NOT NULL AUTO_INCREMENT,
	studentId INT NOT NULL,
	tutorialId INT NOT NULL,
	PRIMARY KEY(studentTutorialId),
	FOREIGN KEY(studentId) REFERENCES Students (studentId),
	FOREIGN KEY(tutorialId) REFERENCES Tutorials(tutorialId),
	UNIQUE(studentId,tutorialId)
);

CREATE TABLE  IF NOT EXISTS TeacherGroups (
teacherGroupId INT  NOT NULL AUTO_INCREMENT,
teachingLoad INT NOT NULL,
teacherId INT NOT NULL,
groupId INT NOT  NULL,
PRIMARY KEY (teacherGroupId),
KEY teacherId (teacherId),
KEY groupId (groupId),
CONSTRAINT teachersgroups_1 FOREIGN KEY (teacherId) REFERENCES teachers (teacherId) ON DELETE CASCADE,
CONSTRAINT teachersgroups_2 FOREIGN KEY (groupId) REFERENCES groups (groupId) ON DELETE CASCADE

);

CREATE TABLE  if not exists Appointments(
appointmentId INT NOT NULL AUTO_INCREMENT, 
dateAppointment DATE NOT NULL, 
hourAppointment TIME NOT NULL,
tutorialId INT NOT NULL,
studentId INT NOT NULL,
PRIMARY KEY (appointmentId),
FOREIGN KEY (tutorialId) REFERENCES Tutorials (tutorialId) ON DELETE CASCADE,
FOREIGN KEY (studentId) REFERENCES Students (studentId) ON DELETE CASCADE,
UNIQUE (dateAppointment, hourAppointment)
);


CREATE TABLE Spaces(
spaceId INT NOT NULL AUTO_INCREMENT, 
spaceName VARCHAR(100) NOT NULL UNIQUE, 
floor INT NOT NULL,
capacity INT NOT NULL,
PRIMARY KEY (spaceId),
CONSTRAINT invalidCapacity CHECK (capacity > 0) 
);


CREATE TABLE if NOT EXISTS Offices( 
officeId INT AUTO_INCREMENT, 
spaceId INT,
PRIMARY KEY (officeId),
FOREIGN KEY (spaceId) REFERENCES Spaces (spaceId) ON DELETE CASCADE ON UPDATE CASCADE
);