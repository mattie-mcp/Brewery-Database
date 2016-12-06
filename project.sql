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
	MangerID	INTEGER,
	CONSTRAINT Employee_BreweryExistConst FOREIGN KEY (BreweryID) REFERENCES BREWERY(BreweryID)
		ON DELETE CASCADE,
	CONSTRAINT ManagerIsEmpConst FOREIGN KEY (MangerID) REFERENCES EMPLOYEE(EmpID)
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
		ON DELETE CASCADE
);

CREATE TABLE SEASON(
	SeasonID		CHAR(5) PRIMARY KEY,
	StartDate		DATE,
	EndDate			DATE,
	CONSTRAINT ValidSeason CHECK(SeasonID IN('Su','Sp','F','W','FW','WS','SpSu','SuF','All','FWSp','SuFW','WSpSu','SpSuF')) 
);

CREATE TABLE BEER(
	BeerID		INTEGER PRIMARY KEY,
	Name		VARCHAR(50),
	SeasonID	CHAR(5),
	Type		VARCHAR(20),
	Abv			DECIMAL,
	BreweryID	INTEGER,
	CONSTRAINT Beer_SeasonConst FOREIGN KEY(SeasonID) REFERENCES SEASON(SeasonID)
		ON DELETE SET NULL,
	CONSTRAINT Beer_BreweryExistConst FOREIGN KEY(BreweryID) REFERENCES BREWERY(BreweryID),
	CONSTRAINT AbvConst CHECK (Abv < 9.51),
	CONSTRAINT LightTypeConst CHECK ((Type = 'light' AND Abv BETWEEN 2.50 AND 4.50) OR Type != 'light'),
	CONSTRAINT RegTypeConst CHECK ((Type = 'regular' AND Abv < 9.51) OR Type != 'regular'),
	CONSTRAINT NonalcTypeConst CHECK ((Type = 'non-alcoholic' AND Abv <= 1.0) OR Type != 'non-alcoholic'),
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

INSERT INTO BREWERY VALUES(1, 'Kyles Kool Kafe', '1234 Brewery Lane, Grand Rapids, MI 49501');
INSERT INTO BREWERY VALUES(2, 'Aarons Place', '1234 Brewery Lane, Grand Rapids, MI 49501');
INSERT INTO BREWERY VALUES(3, 'Michaels Backyard', '1234 Brewery Lane, Grand Rapids, MI 49501');

INSERT INTO FOOD VALUES(2, 'Cheeseburger', 1);
INSERT INTO FOOD VALUES(3, 'Salad', 1);
INSERT INTO FOOD VALUES(4, 'Pizza', 2);
INSERT INTO FOOD VALUES(5, 'Mozzarella Sticks', 2);
INSERT INTO FOOD VALUES(6, 'Wings', 2);
INSERT INTO FOOD VALUES(8, 'Grilled Cheese Sandwich', 3);
INSERT INTO FOOD VALUES(9, 'Spinach and Artichoke Dip', 3);

INSERT INTO EMPLOYEE VALUES(3,  'Andrew Baker', 70000, '572 126th Ave. Allendale, MI 49401', 6165219874, 1, NULL);
INSERT INTO EMPLOYEE VALUES(4,  'Joe Crew', 80000, '931 Home Ave. Allendale, MI 49401', 6165219874, 2, NULL);
INSERT INTO EMPLOYEE VALUES(1,  'Joe Crew', 40000, '48294 Home Ave. Allendale, MI 49401', 6165219874, 1, 3);
INSERT INTO EMPLOYEE VALUES(2, 'Jane Smith', 35000, '48294 Lane St. Allendale, MI 49401', 6165219874, 1, 3);
INSERT INTO EMPLOYEE VALUES(5, 'Jane Smith', 60000, '482 Black St. Allendale, MI 49401', 6165219874, 2, 4);
INSERT INTO EMPLOYEE VALUES(6,  'Andrew Baker', 40200, '572 128th Ave. Allendale, MI 49401', 6165219874, 2, 4);

INSERT INTO JOB VALUES(1, 'Bartender');
INSERT INTO JOB VALUES(2, 'Accountant');
INSERT INTO JOB VALUES(3, 'Brewer');
INSERT INTO JOB VALUES(4, 'Janitor');
INSERT INTO JOB VALUES(5, 'Manager');
INSERT INTO JOB VALUES(6, 'Salesman');

INSERT INTO DISTRIBUTOR VALUES(1, 'Trucking Inc.', '985 2nd St Holland, MI 49423', '5-APR-16', 1);
INSERT INTO DISTRIBUTOR VALUES(2, 'Beverage 2 Go', '152 4th St Kalamazoo, MI 49423', '5-APR-16', 1);
INSERT INTO DISTRIBUTOR VALUES(3, 'Wine and Liquor', '197 Lane Ave Grand Rapids, MI 49426', '5-APR-16', 2);
INSERT INTO DISTRIBUTOR VALUES(4, 'General Sales', '867 Grand River St Holland, MI 49424', '5-APR-16', 2);
INSERT INTO DISTRIBUTOR VALUES(5, 'Van De Distributors', '674 8th St Allendale, MI 49426', '5-APR-16', 3);

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

INSERT INTO BEER VALUES(1, 'Black Horse Premium Draft Beer Black Horse', 'Su', 'regular', 4.74, 1);
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

--Contains IC Constraint Key: Update Brewery breweryID to existing breweryID
UPDATE BREWERY SET BreweryID = 1 WHERE BreweryID = 3;

--Contains IC Foreign-Key: Insert Food BreweryID to a breweryID that does not exist in table Brewery
INSERT INTO FOOD VALUES( 10, 'Breadsticks', 8);

--Contains IC 1-Attribute: Insert into Season an invalid Season
INSERT INTO SEASON VALUES('non', '2-DEC-16', '9-DEC-16');

--Contains IC 2-Attribute: Insert into Beer a beer with an alcohol content of 8 and type of light
INSERT INTO BEER VALUES(10, 'Test Beer', 'Su', 'light', 8.0, 3);


-- Testing other constraints
INSERT INTO BEER VALUES(3, 'Yuengllng Premium Beer D.G. Yuengling and Son', 'Su', 'regular', 4.65, 3);
INSERT INTO BEER VALUES(10, 'Yuengling Porter D.G. Yuengllng and Son', 'Sp', 'regular', 4.49, 2);
INSERT INTO BEER VALUES(11, 'Wurzburger Hofbrau Pilsner Beer Wurtzburger Hofbrauag', 'F', 'regular', 9.52, 2);
INSERT INTO BEER VALUES(12, 'Michaels Wuss Beer', 'SpSuF', 'non-alcoholic', 0.00, 3);
INSERT INTO BEER VALUES(13, 'Utica Club Pilsener Lager Beer West End', 'All', 'light', 2.28, 3);
INSERT INTO BEER VALUES(14, 'Tusker Malt Lager Bia Ni Bora', 'FWSp', 'light', 4.51, 3);
INSERT INTO BEER VALUES(15, 'Tuborg Export Quality Beer G. Heileman', 'WSpSu', 'non-alcoholic',0.09, 1);
INSERT INTO BEER VALUES(16, 'Tsingtao Beer Tsingtao', 2, 'non-alcoholic',1.00, 2);
INSERT INTO BEER VALUES(17, 'Matties Hard Cider', 'SpSuF', 'cider', 4.74, 3);

INSERT INTO BATCH VALUES(10, 2, '5-MAR-2016', 3, 'Clear, slightly red');
INSERT INTO BATCH VALUES(10, 2, '5-MAR-2016', 5, 'Dark');

--Queries

--1)
SELECT	distinct E.Name AS Employee, Br.Name AS Brewery, B.Name AS Beer, Ba.BatchDate AS BrewDate
FROM	Beer B, Brewery Br, Batch Ba, Employee E 
WHERE	E.BreweryID = Br.BreweryID AND
		B.BreweryID = Br.BreweryID AND
		Ba.BeerID = B.BeerID AND
		Ba.EmpID = E.EmpID AND
		B.Abv >=2;

--4 and 6)
select a.breweryid, a.name, a.salary
From employee a
Where salary = (select MAX(salary)
                   From employee b
                           Where a.breweryid = b.breweryid);

--5)
select count(empid), b.breweryid, b.name
From employee e, brewery b
Where e.breweryid = b.breweryid
Group by b.breweryid, b.name
Having count(e.empid) > 2
Order by b.breweryid;

--7)
Select e.name, e.salary, e.address
From employee e
Where empid IN (select empid 
                             From employee e, brewery b
                             Where e.breweryid = b.breweryid and b.name = 'Kyles Kool Kafe');

--10. RANK Query 'Percent Alcohol'
SELECT RANK(4.32) WITHIN GROUP
(ORDER BY abv)
FROM beer;


--11. TOP N Query
SELECT empid, name, salary
FROM employee
WHERE ROWNUM < 3;

SPOOL OFF
