Create database SysmexWaitList;
use SysmexWaitList;

Create table Gender
(
gender_id	Integer(1) primary key,
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
dept_id		Integer primary key,
dept_name	Varchar(100)
) engine = innodb;

Create table Surgeon
(
surgeon_id		Integer primary key,
surgeon_fName	Varchar(50),
surgeon_lName	Varchar(50),
dept_id			Integer,
Foreign key (dept_id) references Department (dept_id)
) engine = innodb;

Create table Referral
(
ref_id		Integer primary key,
ref_date	Date,
ref_by		Varchar(100),
added_to_wl	Date,
fsa_date	Date,
hte			Varchar(3),
nhi			Char(6),
surgeon_id	int,
Foreign key (surgeon_id) references Surgeon (surgeon_id)
) engine = innodb;