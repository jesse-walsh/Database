Create database SysmexWaitList;
use SysmexWaitList;

-- create temporary table to hold data
CREATE TABLE CSVImport (id INT);
ALTER TABLE CSVImport ADD COLUMN ref_date VARCHAR(10);
ALTER TABLE CSVImport ADD COLUMN yrmonth VARCHAR(8);
ALTER TABLE CSVImport ADD COLUMN ref_from VARCHAR(100);
ALTER TABLE CSVImport ADD COLUMN ref_by VARCHAR(100);
ALTER TABLE CSVImport ADD COLUMN nhi VARCHAR(6);
ALTER TABLE CSVImport ADD COLUMN pat_name VARCHAR(100);
ALTER TABLE CSVImport ADD COLUMN dob VARCHAR(10);
ALTER TABLE CSVImport ADD COLUMN gender VARCHAR(6);
ALTER TABLE CSVImport ADD COLUMN dept_name VARCHAR(100);
ALTER TABLE CSVImport ADD COLUMN added_to_wl VARCHAR(10);
ALTER TABLE CSVImport ADD COLUMN surgeon_fullName VARCHAR(100);
ALTER TABLE CSVImport ADD COLUMN fsa_date VARCHAR(10);
ALTER TABLE CSVImport ADD COLUMN hte VARCHAR(3);
ALTER TABLE csvimport DROP COLUMN id;

LOAD DATA LOCAL INFILE "/Users/Rioki/Dropbox/CPITcoursedocuments/DatabaseManagement/waitlistdata.csv"
INTO TABLE CSVImport
FIELDS TERMINATED BY ","
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

Create table Gender
(
gender_id	Integer(1) auto_increment primary key,
gender_type	Varchar(6)
) engine = innodb;

Create table Patient
(
nhi			Char(6) primary key,
pat_fName	Varchar(50),
pat_lName	Varchar(50),
dob			Date,
gender_id	Integer(1),
Foreign key (gender_id) references Gender (gender_id)
) engine = innodb;

Create table Department
(
dept_id		Integer auto_increment primary key,
dept_name	Varchar(100)
) engine = innodb;

Create table Surgeon
(
surgeon_id		Integer auto_increment primary key,
surgeon_fName	Varchar(50),
surgeon_lName	Varchar(50),
dept_id			Integer,
Foreign key (dept_id) references Department (dept_id)
) engine = innodb;

Create table Referral
(
ref_id		Integer auto_increment primary key,
ref_date	Date,
ref_by		Varchar(100),
added_to_wl	Date,
fsa_date	Date,
hte			Varchar(3),
nhi			Char(6),
surgeon_id	int,
Foreign key (surgeon_id) references Surgeon (surgeon_id),
Foreign key (nhi) references Patient (nhi)
) engine = innodb;

-- Allow for future changes to the gender column
INSERT INTO Gender(gender_type) SELECT DISTINCT (gender) FROM CSVImport;

INSERT IGNORE INTO Patient (
	nhi,
    pat_fName,
    pat_lName,
    dob,
    gender_id
) SELECT 
	nhi,
    SUBSTRING(pat_name, 1, LOCATE(' ', pat_name) - 1) AS pat_fName,
	REVERSE(SUBSTRING(REVERSE(pat_name), 1, LOCATE(' ', REVERSE(pat_name)) - 1)) AS pat_lName,
    dob,
    Gender.gender_id FROM CSVImport 
	INNER JOIN Gender ON Gender.gender_type = CSVImport.gender;

INSERT IGNORE INTO Department (
	dept_name
) SELECT 
	nhi,
    SUBSTRING(pat_name, 1, LOCATE(' ', pat_name) - 1) AS pat_fName,
	REVERSE(SUBSTRING(REVERSE(pat_name), 1, LOCATE(' ', REVERSE(pat_name)) - 1)) AS pat_lName,
    dob,
    Gender.gender_id FROM CSVImport 
	INNER JOIN Gender ON Gender.gender_type = CSVImport.gender;


