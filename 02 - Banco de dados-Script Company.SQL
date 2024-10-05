-- Criando o schema
create schema if not exists company_constraints;
use company_constraints;

select * from information_schema.table_constraints
	where constraint_schema = 'company_constraints';

CREATE TABLE employee(
	Fname varchar(15) not null,
    Minit char,
    Lname varchar(15) not null,
    Ssn char(9) not null, 
    Bdate date,
    Address varchar(30),
    Sex char,
    Salary decimal(10,2),
    Super_ssn char(9),
    Dno int not null,
    constraint chk_salary_employee check (Salary > 2000.0),
    constraint pk_employee primary key (Ssn)
);

ALTER TABLE employee 
	ADD CONSTRAINT fk_employee 
	FOREIGN KEY(Super_ssn) REFERENCES employee(Ssn)
    ON DELETE SET NULL
    ON UPDATE CASCADE;

ALTER TABLE employee MODIFY Dno int NOT NULL DEFAULT 1;

DESC employee;

CREATE TABLE department(
	Dname varchar(15) not null,
    Dnumber int not null,
    Mgr_ssn char(9) not null,
    Mgr_start_date date, 
    Dept_create_date date,
    CONSTRAINT chk_date_dept CHECK (Dept_create_date < Mgr_start_date),
    CONSTRAINT pk_dept PRIMARY KEY (Dnumber),
    CONSTRAINT unique_name_dept UNIQUE(Dname),
    FOREIGN KEY (Mgr_ssn) REFERENCES employee(Ssn)
);

ALTER TABLE department DROP FOREIGN KEY department_ibfk_1;

ALTER TABLE department 
	ADD CONSTRAINT fk_dept 
	FOREIGN KEY(Mgr_ssn) REFERENCES employee(Ssn)
    ON UPDATE CASCADE;

DESC department;

CREATE TABLE dept_locations(
	Dnumber int not null,
	Dlocation varchar(15) not null,
    CONSTRAINT pk_dept_locations PRIMARY KEY (Dnumber, Dlocation),
    CONSTRAINT fk_dept_locations FOREIGN KEY (Dnumber) REFERENCES department(Dnumber)
);

ALTER TABLE dept_locations DROP FOREIGN KEY fk_dept_locations;

ALTER TABLE dept_locations 
	ADD CONSTRAINT fk_dept_locations 
	FOREIGN KEY (Dnumber) REFERENCES department(Dnumber)
	ON DELETE CASCADE
    ON UPDATE CASCADE;

CREATE TABLE project(
	Pname varchar(15) not null,
	Pnumber int not null,
    Plocation varchar(15),
    Dnum int not null,
    PRIMARY KEY (Pnumber),
    CONSTRAINT unique_project UNIQUE (Pname),
    CONSTRAINT fk_project FOREIGN KEY (Dnum) REFERENCES department(Dnumber)
);

CREATE TABLE works_on(
	Essn char(9) not null,
    Pno int not null,
    Hours decimal(3,1) not null,
    PRIMARY KEY (Essn, Pno),
    CONSTRAINT fk_employee_works_on FOREIGN KEY (Essn) REFERENCES employee(Ssn),
    CONSTRAINT fk_project_works_on FOREIGN KEY (Pno) REFERENCES project(Pnumber)
);

DROP TABLE IF EXISTS dependent;

CREATE TABLE dependent(
	Essn char(9) not null,
    Dependent_name varchar(15) not null,
    Sex char,
    Bdate date,
    Relationship varchar(8),
    PRIMARY KEY (Essn, Dependent_name),
    CONSTRAINT fk_dependent FOREIGN KEY (Essn) REFERENCES employee(Ssn)
);

SHOW TABLES;
DESC dependent;
