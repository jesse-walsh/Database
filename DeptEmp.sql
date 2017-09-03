Drop database if exists DeptEmp;
create database DeptEmp;
use DeptEmp;
create table Department(
deptID int primary key,
deptName varchar(20)
) engine = InnoBD;

create table Employee(
empID int,
fName varchar(20),
lName varchar(20),
dob date,
salary decimal(12,2),
deptID int,
primary key (empID),
FOREIGN KEY (deptID) REFERENCES
Department(deptID)
) engine = InnoBD;