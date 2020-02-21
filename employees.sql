--  Sample employee database
--  See changelog table for details
--  Copyright (C) 2007,2008, MySQL AB
--
--  Original data created by Fusheng Wang and Carlo Zaniolo
--  http://www.cs.aau.dk/TimeCenter/software.htm
--  http://www.cs.aau.dk/TimeCenter/Data/employeeTemporalDataSet.zip
--
--  Current schema by Giuseppe Maxia
--  Data conversion from XML to relational by Patrick Crews
--
-- This work is licensed under the
-- Creative Commons Attribution-Share Alike 3.0 Unported License.
-- To view a copy of this license, visit
-- http://creativecommons.org/licenses/by-sa/3.0/ or send a letter to
-- Creative Commons, 171 Second Street, Suite 300, San Francisco,
-- California, 94105, USA.
--
--  DISCLAIMER
--  To the best of our knowledge, this data is fabricated, and
--  it does not correspond to real people.
--  Any similarity to existing people is purely coincidental.
--

DROP DATABASE IF EXISTS employees;
CREATE DATABASE IF NOT EXISTS employees;
USE employees;

-- define some handy variables
set @unknown_date_of_birth='1900-01-01';
set @unknown_date_of_hiring='1920-01-01';
set @unknown_date_of_terminate='2222-01-01';
set @unknown_date_of_probation_end='1920-07-01';
set @begin_of_all_times='1000-01-01';
set @end_of_all_times='9999-12-31';

SELECT '*** CREATING DATABASE STRUCTURE ...' as 'INFO';

DROP TABLE IF EXISTS dept_emp,
                     dept_manager,
                     titles,
                     salaries,
                     employees,
                     departments;

/*!50503 set default_storage_engine = InnoDB */;
/*!50503 select CONCAT('storage engine: ', @@default_storage_engine) as INFO */;

CREATE TABLE employees (
    emp_no                INT                  NOT NULL AUTO_INCREMENT COMMENT 'internal numeric unique id, used as primary key',
    employee_id           VARCHAR(64)          NOT NULL DEFAULT '' COMMENT 'customizable ID string for the employees, e.g. ETWeb-54321-GEWI, should be unique',
    date_of_birth         DATE                 NOT NULL DEFAULT '1900-01-01',
    first_name            VARCHAR(128)         NOT NULL,
    last_name             VARCHAR(128)         NOT NULL,
    middle_names          VARCHAR(128)         NOT NULL DEFAULT '',
    gender                ENUM ('D', 'M','F')  NOT NULL DEFAULT 'D',
    date_of_hiring        DATE                 NOT NULL DEFAULT '1920-01-01',
    date_of_termination   DATE                 NOT NULL DEFAULT '2222-01-01',
    date_of_probation_end DATE                 NOT NULL DEFAULT '1920-07-01',
    PRIMARY KEY (emp_no)
);

CREATE TABLE departments (
    dept_no     CHAR(4)         NOT NULL,
    dept_name   VARCHAR(40)     NOT NULL,
    PRIMARY KEY (dept_no),
    UNIQUE  KEY (dept_name)
);

CREATE TABLE dept_manager (
   -- emp_no       INT             NOT NULL,
   emp_no       INT             NOT NULL REFERENCES employees(emp_no),
   -- dept_no      CHAR(4)         NOT NULL,
   dept_no      CHAR(4)         NOT NULL REFERENCES departments(dept_no),
   from_date    DATE            NOT NULL,
   to_date      DATE            NOT NULL,
   FOREIGN KEY (emp_no)  REFERENCES employees (emp_no)    ON DELETE CASCADE,
   FOREIGN KEY (dept_no) REFERENCES departments (dept_no) ON DELETE CASCADE,
   PRIMARY KEY (emp_no,dept_no, from_date)
);

CREATE TABLE dept_emp (
    -- emp_no      INT             NOT NULL,
    emp_no      INT             NOT NULL REFERENCES employees(emp_no),
    -- dept_no     CHAR(4)         NOT NULL,
    dept_no     CHAR(4)         NOT NULL REFERENCES departments(dept_no),
    from_date   DATE            NOT NULL,
    to_date     DATE            NOT NULL,
    FOREIGN KEY (emp_no)  REFERENCES employees   (emp_no)  ON DELETE CASCADE,
    FOREIGN KEY (dept_no) REFERENCES departments (dept_no) ON DELETE CASCADE,
    PRIMARY KEY (emp_no,dept_no, from_date)
);

CREATE TABLE titles (
    -- emp_no      INT             NOT NULL,
    emp_no      INT             NOT NULL REFERENCES employees(emp_no),
    title       VARCHAR(50)     NOT NULL,
    from_date   DATE            NOT NULL,
    to_date     DATE,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no) ON DELETE CASCADE,
    PRIMARY KEY (emp_no,title, from_date)
)
;

CREATE TABLE salaries (
    -- emp_no      INT             NOT NULL,
    emp_no      INT             NOT NULL REFERENCES employees(emp_no),
    salary      INT             NOT NULL,
    from_date   DATE            NOT NULL,
    to_date     DATE            NOT NULL,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no) ON DELETE CASCADE,
    PRIMARY KEY (emp_no, from_date)
)
;

CREATE TABLE salary_groups (
    sg_no       INT             NOT NULL AUTO_INCREMENT COMMENT 'internal numeric unique id, used as primary key',
    sg_name     VARCHAR(40)     NOT NULL COMMENT 'name of the salary group, e.g. EG 12',
    PRIMARY     KEY (sg_no),
    UNIQUE      KEY (sg_name)
)
;

CREATE TABLE sg_emp (
    -- emp_no      INT             NOT NULL,
    emp_no      INT             NOT NULL REFERENCES employees(emp_no),
    -- dept_no     CHAR(4)         NOT NULL,
    sg_no       INT             NOT NULL REFERENCES salary_groups(sg_no),
    from_date   DATE            NOT NULL,
    to_date     DATE            NOT NULL,
    FOREIGN KEY (emp_no)  REFERENCES employees (emp_no)  ON DELETE CASCADE,
    FOREIGN KEY (sg_no)   REFERENCES salary_groups (sg_no) ON DELETE CASCADE,
    PRIMARY KEY (emp_no,sg_no, from_date)
);

CREATE OR REPLACE VIEW dept_emp_latest_date AS
    SELECT d.emp_no, e.last_name, e.first_name, MAX(from_date) AS from_date, MAX(to_date) AS to_date
    FROM dept_emp AS d, employees AS e
    WHERE d.emp_no=e.emp_no
    GROUP BY d.emp_no;

# shows only the current department for each employee
CREATE OR REPLACE VIEW current_dept_emp AS
    SELECT l.emp_no, dept_no, l.from_date, l.to_date
    FROM dept_emp d
        INNER JOIN dept_emp_latest_date l
        ON d.emp_no=l.emp_no AND d.from_date=l.from_date AND l.to_date = d.to_date;


flush /*!50503 binary */ logs;


SELECT '*** LOADING DATA ...' as 'INFO';
SELECT 'LOADING departments' as 'INFO';
source load_departments.dump ;
SELECT ' * LOADING employees' as 'INFO';
source load_employees.dump ;
SELECT ' * LOADING dept_emp' as 'INFO';
source load_dept_emp.dump ;
SELECT ' * LOADING dept_manager' as 'INFO';
source load_dept_manager.dump ;
SELECT ' * LOADING titles' as 'INFO';
source load_titles.dump ;
SELECT ' * LOADING salaries' as 'INFO';
source load_salaries1.dump ;
source load_salaries2.dump ;
source load_salaries3.dump ;

source show_elapsed.sql ;
