SPOOL project.out
SET ECHO ON

/* 
CIS 353
 - Database Design Project 
Aaron Teague
Kyle Hekhuis
Mattie Phillips
Michael Strating
*/ 

DROP TABLE SEASON CASCADE CONSTRAINTS;
DROP TABLE BREWERY CASCADE CONSTRAINTS;
DROP TABLE BEER CASCADE CONSTRAINTS;
DROP TABLE FOOD CASCADE CONSTRAINTS;
DROP TABLE CERTIFIED CASCADE CONSTRAINTS;
DROP TABLE EMPLOYEE CASCADE CONSTRAINTS;
DROP TABLE JOB CASCADE CONSTRAINTS;
DROP TABLE DISTRIBUTOR CASCADE CONSTRAINTS;
DROP TABLE INGREDIENTS CASCADE CONSTRAINTS;
DROP TABLE BATCH CASCADE CONSTRAINTS;

CREATE TABLE BREWERY(
	BreweryID	INTEGER PRIMARY KEY,
	Name		VARCHAR2(30) NOT NULL,
	Location	VARCHAR2(60)
);


CREATE TABLE FOOD(
	FoodID		INTEGER PRIMARY KEY, 
	Name		VARCHAR2(30) NOT NULL, 
	BreweryID	INTEGER NOT NULL,
	CONSTRAINT Food_BreweryExistConst 
		FOREIGN KEY (BreweryID) 
		REFERENCES BREWERY(BreweryID)
		ON DELETE CASCADE
);


CREATE TABLE EMPLOYEE(
	EmpID		INTEGER PRIMARY KEY, 
	Name		VARCHAR2(30) NOT NULL, 
	Salary		INTEGER NOT NULL, 
	Address		VARCHAR2(60), 
	PhoneNumber	INTEGER, 
	BreweryID	INTEGER NOT NULL, 
	ManagerID	INTEGER,
	CONSTRAINT Employee_BreweryExistConst FOREIGN KEY (BreweryID) REFERENCES BREWERY(BreweryID)
		ON DELETE CASCADE,
	CONSTRAINT ManagerIsEmpConst FOREIGN KEY (ManagerID) REFERENCES EMPLOYEE(EmpID)
);


CREATE TABLE JOB(
	JobID		INTEGER PRIMARY KEY,
	Title		VARCHAR2(20)
);


CREATE TABLE DISTRIBUTOR(
	DistID		INTEGER PRIMARY KEY,
	Name		VARCHAR2(20),
	Location	VARCHAR2(60),
	ContractStart	DATE,
	BreweryID	INTEGER,
	CONSTRAINT  Distributor_BreweryExistConst FOREIGN KEY(BreweryID) REFERENCES BREWERY(BreweryID)
		ON DELETE CASCADE,
	CONSTRAINT Distributor_BreweryUnique UNIQUE(BreweryID)
);

CREATE TABLE SEASON(
	SeasonID		CHAR(5) PRIMARY KEY,
	StartDate		DATE,
	EndDate			DATE,
	CONSTRAINT ValidSeasonConst CHECK(SeasonID IN('Su','Sp','F','W','FW','WS','SpSu','SuF','All','FWSp','SuFW','WSpSu','SpSuF')) 
);

CREATE TABLE BEER(
	BeerID		INTEGER PRIMARY KEY,
	Name		VARCHAR(60),
	SeasonID	CHAR(5),
	Type		VARCHAR(20),
	Abv			DECIMAL(9,2),
	BreweryID	INTEGER,
	CONSTRAINT Beer_SeasonConst FOREIGN KEY(SeasonID) REFERENCES SEASON(SeasonID)
		ON DELETE SET NULL,
	CONSTRAINT Beer_BreweryExistConst FOREIGN KEY(BreweryID) REFERENCES BREWERY(BreweryID),
	CONSTRAINT AbvConst CHECK (Abv < 9.51),
	CONSTRAINT LightTypeConst CHECK ((Type = 'light' AND Abv BETWEEN 2.50 AND 4.50) OR Type != 'light'),
	CONSTRAINT RegTypeConst CHECK ((Type = 'regular' AND Abv BETWEEN 4.50 AND 9.51) OR Type != 'regular'),
	CONSTRAINT NonalcTypeConst CHECK ((Type = 'non-alcoholic' AND Abv BETWEEN 0.10 AND 1.00) OR Type != 'non-alcoholic'),
	CONSTRAINT TypeConst CHECK (Type IN ('light', 'regular', 'non-alcoholic'))
);

CREATE TABLE BATCH(
	BeerID		INTEGER,
	EmpID		INTEGER,
	BatchDate	DATE,
	PH			INTEGER,
	Color		CHAR(50),
	PRIMARY KEY (BeerID, EmpID, BatchDate),
	CONSTRAINT Batch_BeerConst FOREIGN KEY(BeerID) REFERENCES BEER(BeerID)
		ON DELETE CASCADE,
	CONSTRAINT Batch_EmployeeConst FOREIGN KEY(EmpID) REFERENCES EMPLOYEE(EmpID)
		ON DELETE CASCADE
);
    

CREATE TABLE INGREDIENTS(
	BeerID		INTEGER,
	Ingredient	CHAR(30),
	PRIMARY KEY (BeerID, Ingredient)    
);


CREATE TABLE CERTIFIED(
	EmpID		INTEGER,
	JobID		INTEGER,
	PRIMARY KEY(EmpID, JobID)
);


SET FEEDBACK OFF
----- Inserting values into Brewery
INSERT INTO BREWERY VALUES(1, 'Kyles Kafe', '12345 Craftsman St, Grand Rapids, MI 49501');
INSERT INTO BREWERY VALUES(2, 'Aarons Place', '12346 Division St, Grand Rapids, MI 49501');
INSERT INTO BREWERY VALUES(3, 'Michaels Backyard', '12347 Brewery Lane, Grand Rapids, MI 49501');
----- Inserting values into Food
INSERT INTO FOOD VALUES(2, 'Cheeseburger', 1);
INSERT INTO FOOD VALUES(3, 'Salad', 1);
INSERT INTO FOOD VALUES(4, 'Pizza', 2);
INSERT INTO FOOD VALUES(5, 'Mozzarella Sticks', 2);
INSERT INTO FOOD VALUES(6, 'Wings', 2);
INSERT INTO FOOD VALUES(8, 'Grilled Cheese Sandwich', 3);
INSERT INTO FOOD VALUES(9, 'Spinach and Artichoke Dip', 3);
----- Inserting values into Employee
INSERT INTO EMPLOYEE VALUES(3,  'Andrew Baker', 70000, '572 126th Ave. Allendale, MI 49401', 6165219874, 1, NULL);
INSERT INTO EMPLOYEE VALUES(4,  'Joe Crew', 80000, '931 Home Ave. Allendale, MI 49401', 6165219874, 2, NULL);
INSERT INTO EMPLOYEE VALUES(1,  'Ella Crew', 40000, '48294 Home Ave. Allendale, MI 49401', 6165219874, 1, 3);
INSERT INTO EMPLOYEE VALUES(2, 'Jane Smith', 35000, '48294 Lane St. Allendale, MI 49401', 6165219874, 1, 3);
INSERT INTO EMPLOYEE VALUES(5, 'Brian Smith', 60000, '482 Black St. Allendale, MI 49401', 6165219874, 2, 4);
INSERT INTO EMPLOYEE VALUES(6,  'Andrew Broker', 40200, '572 128th Ave. Allendale, MI 49401', 6165219874, 2, 4);
INSERT INTO EMPLOYEE VALUES(7, 'Elliott Smith', 81000, '482 Black St. Allendale, MI 49401', 6165219874, 3, NULL);
INSERT INTO EMPLOYEE VALUES(8,  'Martha Craft', 78000, '572 128th Ave. Allendale, MI 49401', 6165219874, 3, NULL);
----- Inserting values into JOB
INSERT INTO JOB VALUES(1, 'Bartender');
INSERT INTO JOB VALUES(2, 'Accountant');
INSERT INTO JOB VALUES(3, 'Brewer');
INSERT INTO JOB VALUES(4, 'Janitor');
INSERT INTO JOB VALUES(5, 'Manager');
INSERT INTO JOB VALUES(6, 'Salesman');
----- Inserting values into DISTRIBUTOR
INSERT INTO DISTRIBUTOR VALUES(1, 'Trucking Inc.', '985 2nd St Holland, MI 49423', '5-APR-16', 1);
INSERT INTO DISTRIBUTOR VALUES(3, 'Wine and Liquor', '197 Lane Ave Grand Rapids, MI 49426', '5-APR-16', 2);
INSERT INTO DISTRIBUTOR VALUES(5, 'Van De Distributors', '674 8th St Allendale, MI 49426', '5-APR-16', 3);
----- Inserting values into SEASON
INSERT INTO SEASON VALUES('Su', '5-APR-16', '8-APR-16');
INSERT INTO SEASON VALUES('Sp', '5-APR-16', '8-APR-16');
INSERT INTO SEASON VALUES('F', '5-APR-16', '8-APR-16');
INSERT INTO SEASON VALUES('W', '5-APR-16', '8-APR-16');
INSERT INTO SEASON VALUES('FW', '5-APR-16', '8-APR-16');
INSERT INTO SEASON VALUES('WS', '5-APR-16', '8-APR-16');
INSERT INTO SEASON VALUES('SpSu', '5-APR-16', '8-APR-16');
INSERT INTO SEASON VALUES('SuF', '5-APR-16', '8-APR-16');
INSERT INTO SEASON VALUES('All', '5-APR-16', '8-APR-16');
INSERT INTO SEASON VALUES('FWSp', '5-APR-16', '8-APR-16');
INSERT INTO SEASON VALUES('SuFW', '5-APR-16', '8-APR-16');
INSERT INTO SEASON VALUES('WSpSu', '5-APR-16', '8-APR-16');
INSERT INTO SEASON VALUES('SpSuF', '5-APR-16', '8-APR-16');
----- Inserting values into BEER
INSERT INTO BEER VALUES(1, 'Black Horse Premium Draft Beer Black Horse', 'Su', 'regular', 4.74, 3);
INSERT INTO BEER VALUES(2, 'Cerveza Tecate Beer Cervecerla Cauhtemoc', 'Sp', 'regular', 4.59, 2);
INSERT INTO BEER VALUES(3, 'Genesee Beer Genesee', 'F', 'regular', 5.03, 3);
INSERT INTO BEER VALUES(4, 'Molson Light Beer Molson', 'W', 'light', 2.51, 1);
INSERT INTO BEER VALUES(5, 'Rheingold Extra Light Beer Rheingold', 'FW', 'light', 4.32, 2);
INSERT INTO BEER VALUES(6, 'Watneys London Light Beer Watney Combe Reid', 'WS', 'light', 3.56, 3);
INSERT INTO BEER VALUES(7, 'Clausthaler Non-Alcoholic Brauerei', 'SpSu', 'non-alcoholic', 0.44, 1);
INSERT INTO BEER VALUES(8, 'Elan Swiss Brew Non-Alcoholic Malt Beverage', 'SuF', 'non-alcoholic', 0.50, 2);
INSERT INTO BEER VALUES(9, 'Kingsbury Non-Alcoholic Malt Bev. G. Heileman', 'SpSuF', 'non-alcoholic', 0.10, 3);
----- Inserting values into Ingredients
INSERT INTO INGREDIENTS VALUES(1,'Hops');
INSERT INTO INGREDIENTS VALUES(1,'Yeast');
INSERT INTO INGREDIENTS VALUES(2,'Hops');
INSERT INTO INGREDIENTS VALUES(3,'Hops');
INSERT INTO INGREDIENTS VALUES(3,'Barley');
INSERT INTO INGREDIENTS VALUES(3,'Water');
INSERT INTO INGREDIENTS VALUES(4,'Hops');
INSERT INTO INGREDIENTS VALUES(4,'Bourbon');
INSERT INTO INGREDIENTS VALUES(5,'Hops');
INSERT INTO INGREDIENTS VALUES(6,'Fruit');
INSERT INTO INGREDIENTS VALUES(7,'Hops');
INSERT INTO INGREDIENTS VALUES(7,'Barley');
INSERT INTO INGREDIENTS VALUES(8,'Hops');
INSERT INTO INGREDIENTS VALUES(9,'Water');
INSERT INTO INGREDIENTS VALUES(9,'Hops');
INSERT INTO INGREDIENTS VALUES(8,'Yeast');
INSERT INTO INGREDIENTS VALUES(6,'Water');
INSERT INTO INGREDIENTS VALUES(5,'Water');
INSERT INTO INGREDIENTS VALUES(4,'Yeast');
INSERT INTO INGREDIENTS VALUES(4,'Water');
----- Inserting values into Batch
INSERT INTO BATCH VALUES(1, 6, '5-APR-16', 3, 'Orange');
INSERT INTO BATCH VALUES(1, 6, '4-APR-16', 3, 'Clear');
INSERT INTO BATCH VALUES(8, 2, '5-APR-16', 3, 'Clear, slightly red');
INSERT INTO BATCH VALUES(4, 2, '3-APR-16', 5, 'Dark');
INSERT INTO BATCH VALUES(2, 6, '5-APR-16', 4, 'Orange');
INSERT INTO BATCH VALUES(3, 6, '5-APR-16', 4, 'Clear');
INSERT INTO BATCH VALUES(4, 2, '5-APR-16', 3, 'Clear, slightly red');
INSERT INTO BATCH VALUES(5, 2, '5-APR-16', 5, 'Dark');
INSERT INTO BATCH VALUES(6, 2, '5-APR-16', 5, 'Dark');
INSERT INTO BATCH VALUES(7, 6, '5-APR-16', 4, 'Orange');
INSERT INTO BATCH VALUES(9, 6, '5-APR-16', 4, 'Clear');
----- Inserting values into Certified
INSERT INTO CERTIFIED VALUES(6, 1);
INSERT INTO CERTIFIED VALUES(6, 3);
INSERT INTO CERTIFIED VALUES(1, 2);
INSERT INTO CERTIFIED VALUES(2, 4);
INSERT INTO CERTIFIED VALUES(2, 3);
INSERT INTO CERTIFIED VALUES(3, 5);
INSERT INTO CERTIFIED VALUES(4, 6);
INSERT INTO CERTIFIED VALUES(5, 4);

SET FEEDBACK ON
COMMIT;

-- Simple select of all database tables
SELECT * FROM BREWERY;
SELECT * FROM FOOD;
SELECT * FROM EMPLOYEE;
SELECT * FROM JOB;
SELECT * FROM DISTRIBUTOR;
SELECT * FROM BEER;
SELECT * FROM BATCH;
SELECT * FROM INGREDIENTS;
SELECT * FROM CERTIFIED;


--Testing: Primary Key constrating of table Brewery
--Contains IC Constraint Key: Update Brewery breweryID to existing breweryID
UPDATE BREWERY SET BreweryID = 1 WHERE BreweryID = 3;
INSERT INTO BREWERY VALUES(1, 'Test Brewery', 'A cool location');

--Testing: Food_BreweryExistConst
--Contains IC Foreign-Key: Insert Food BreweryID to a breweryID that does not exist in table Brewery
INSERT INTO FOOD VALUES( 10, 'Breadsticks', 8);
Update FOOD set BreweryId = 102 where FoodID = 2;

--Testing IC Employee_BreweryExistConst:Employee BreweryID to a BreweryID that does not exist in table Brewery
INSERT INTO EMPLOYEE VALUES(30, 'Jared Barense', 45000, '234 48th Ave. Allendale, MI 49401', 6168326578, 4, NULL);
UPDATE EMPLOYEE SET BreweryID = 4 WHERE BreweryID = 3;

--Testing IC ManagerIsEmpConst: Employee ManagerID to a ManagerID that is not an employee
INSERT INTO EMPLOYEE VALUES(30, 'Jared Barense', 45000, '234 48th Ave. Allendale, MI 49401', 6168326578, 3, 45);
UPDATE EMPLOYEE SET ManagerID = 28 WHERE ManagerID = 3;

--Testing: Job ID primary key constraint
--Testing IC Constraint Key: Update Job JobID to existing JobID
UPDATE JOB SET JobID = 1 WHERE JobID = 3;

--Testing IC Distributor_BreweryExistConst: Foreign Key BreweryID is a real BreweryID
INSERT INTO DISTRIBUTOR VALUES(6, 'JJ Packing Co.', '754 James St Allendale, MI 49426', '5-APR-16', 4);
UPDATE DISTRIBUTOR SET BreweryID = 4 WHERE BreweryID = 1;

--Testing IC Distributor_BreweryUnique: Unique BreweryID
INSERT INTO DISTRIBUTOR VALUES(2, 'Beverage 2 Go', '152 4th St Kalamazoo, MI 49423', '5-APR-16', 1);
UPDATE DISTRIBUTOR SET BreweryID = 3 WHERE BreweryID = 1;

--Testing: ValidSeasonConst
--Contains IC 1-Attribute: Insert into Season an invalid Season
INSERT INTO SEASON VALUES('non', '2-DEC-16', '9-DEC-16');
Update Season Set SeasonId = 'XX' where SeasonId = 'Su';

--Testing: LIGHTTYPECONST
--Contains IC 2-Attribute: Insert into Beer a beer with an alcohol content of 8 and type of light
INSERT INTO BEER VALUES(10, 'Test Beer', 'Su', 'light', 8.0, 3);
UPDATE BEER SET Type = 'light' where BeerId = 2;

--Testing: REGTYPECONST
INSERT INTO BEER VALUES(10, 'Yuengling Porter D.G. Yuengllng and Son', 'Sp', 'regular', 4.49, 2);
UPDATE BEER SET Abv = 2 where BeerId = 2;

--Testing: NONALCTYPECONST
INSERT INTO BEER VALUES(15, 'Tuborg Export Quality Beer G. Heileman', 'WSpSu', 'non-alcoholic',0.09, 1);
UPDATE BEER SET Type = 'non-alcoholic' where BeerId = 2;

--Testing: SEASONCONST
INSERT INTO BEER VALUES(16, 'Tsingtao Beer Tsingtao', 2, 'non-alcoholic',1.00, 2);
UPDATE BEER SET SeasonId = 0 where BeerId = 3;

--Testing: TYPECONST
INSERT INTO BEER VALUES(17, 'Matties Hard Cider', 'SpSuF', 'cider', 4.74, 3);
UPDATE BEER SET Type = 'lager' where BeerId = 4;

--Testing: Batch_BeerConst
INSERT INTO BATCH VALUES(200, 2, '5-MAR-2016', 5, 'Dark');
Update Batch set BeerId = 200 where BeerId = 3;

--Testing: Batch_EmployeeConst 
INSERT INTO BATCH VALUES(7, 800, '5-MAR-2016', 5, 'Dark');
Update Batch set EmpId = 200 where BeerId = 3;

--Queries

--1. Employee, brewery and batch information for all beers with an alcohol content greater than or equal to 2
SELECT	distinct E.Name AS Employee, Br.Name AS Brewery, B.Name AS Beer, Ba.BatchDate AS BrewDate
FROM	Beer B, Brewery Br, Batch Ba, Employee E 
WHERE	E.BreweryID = Br.BreweryID AND
		B.BreweryID = Br.BreweryID AND
		Ba.BeerID = B.BeerID AND
		Ba.EmpID = E.EmpID AND
		B.Abv >=2;

--2. Select all employees that make more than 60% of their manager's salaries
Select e1.Name as Employee, e1.Salary as EmployeeSalary, e2.Name as Manager, e2.Salary as ManagerSalary
From Employee e1, Employee e2
Where e2.EmpId = e1.ManagerId and (e1.Salary/e2.Salary) > .6;

--3. All distributors for brewery 1 and 3
Select Name
From Distributor
Where Distributor.BreweryId = 1
UNION
Select Name
From Distributor
Where Distributor.BreweryId = 3; 

--4 and 6. Select the employees who make the most money from each brewery
select a.breweryid, a.name, a.salary
From employee a
Where salary = (select MAX(salary)
                   From employee b
                           Where a.breweryid = b.breweryid);

--5. Select the number of employees from each brewery that have 2 or more employees
select count(empid), b.breweryid, b.name
From employee e, brewery b
Where e.breweryid = b.breweryid
Group by b.breweryid, b.name
Having count(e.empid) >= 2
Order by b.breweryid;

--7. Select the employee information for those who work at Kyles Kool Kafe
Select e.name, e.salary, e.address
From employee e
Where empid IN (select empid 
                             From employee e, brewery b
                             Where e.breweryid = b.breweryid and b.name = 'Kyles Kool Kafe');

--8. For every beer that came from a clear batches, find breweries that sell that beer
Select	breweryid, name
From	Brewery r
Where	not exists((select a.beerid
					From batch a
					Where a.color = 'Clear')
					MINUS   
					(select	a.beerid
					From	beer  b, batch a
					Where	r.breweryid = b.breweryid AND
							b.beerid = a.beerid AND
							a.color = 'Clear'));

--9. For all employees, find any batchID and dates they may or may not have
SELECT		distinct E.EmpID, E.Name, B.BeerID, B.BatchDate
FROM		Employee E LEFT OUTER JOIN Batch B ON E.EmpID = B.EmpID
ORDER BY	E.EmpID;

--10. Find the ranking of ABV 4.32 among all beers
SELECT RANK(4.32) WITHIN GROUP
(ORDER BY abv)
FROM beer;

--11. Select employee ID, name, and salary for 3 employees
SELECT empid, name, salary
FROM employee
WHERE ROWNUM < 3;

--Extra Queries
--Find all jobs employees are certified for
SELECT		E.EmpID, E.Name, J.Title
FROM		Employee E, Certified C, Job J
WHERE E.EmpId = C.EmpId and C.JobId = J.JobId;

--Select season information for all beers
SELECT B.Name, B.Type, S.SeasonId, S.StartDate, S.EndDate
FROM Beer B, Season S
Where B.SeasonID = S.SeasonID;

SPOOL OFF