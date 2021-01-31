CREATE DATABASE car_sale_two
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    CONNECTION LIMIT = -1;
	
--  create table	
CREATE TABLE "car" (
  "vin_id" SERIAL,
  "color" VARCHAR(100),
  "make" VARCHAR(100),
  "model" VARCHAR(100),
  "_year" NUMERIC(4),
  PRIMARY KEY ("vin_id")
);

-- insert values
INSERT INTO car(color, make, model, _year)
VALUES('green','Dodge','Dart','1976'),
('red','Ford','Dart','1976'),
('orange','Chevy','Dart','1976');

-- physically confirm view
select * from car;

--  create table	
CREATE TABLE "customer" (
  "customer_id" SERIAL,
  "first_name" VARCHAR(100),
  "last_name" VARCHAR(100),
  "birth_date" DATE,
  "email" VARCHAR(150),
  PRIMARY KEY ("customer_id")
);

INSERT INTO customer(first_name, last_name, birth_date, email)
VALUES('Alex','Trebec','1980-01-01','alexismissed@trebec.com'),
('Babe','Ruth','1987-01-01','thebabeismissed@baseball.com'),
('Cat','Stevens','1960-01-01','catmissed@stevens.com');

-- physically confirm view
select * from customer;


--  create table	
CREATE TABLE "mechanic" (
  "mechanic_id" SERIAL,
  "first_name" VARCHAR(100),
  "last_name" VARCHAR(100),
  "mech_hire_date" DATE,
  PRIMARY KEY ("mechanic_id")
);

-- insert values
INSERT INTO mechanic(first_name, last_name,mech_hire_date)
VALUES('Daisy','Dukes','1980-01-01'),
('Heather','Locklear','1981-01-01'),
('Bo','Derek','1982-01-01');

-- physically confirm view
select * from mechanic;


--  create table
CREATE TABLE "parts" (
  "part_id" SERIAL,
  "part_name" VARCHAR(150),
  "part_cost" NUMERIC(10,2),
  "part_quantity" INTEGER,
  PRIMARY KEY ("part_id")
);

INSERT INTO parts(part_name, part_cost, part_quantity)
VALUES('xcaliber', 34.00,4),
('xshield', 34.00,2),
('xfluxcapacitor', 100.00,1);



--  create table
CREATE TABLE "salesperson" (
  "salesperson_id" SERIAL,
  "first_name" VARCHAR(100),
  "last_name" VARCHAR(100),
  "sales_hire_date" DATE,
  PRIMARY KEY ("salesperson_id")
);

INSERT INTO salesperson(first_name, last_name, sales_hire_date)
VALUES('Pam','Anderson','1990-01-01'),
('Kathy','Ireland','1990-05-01'),
('Valerie','Snugglebear','1972-11-20');

select * from salesperson;



--  create table

CREATE TABLE "services" (
  "services_id" SERIAL,
  "services_name" VARCHAR(150),
  PRIMARY KEY ("services_id")
);

INSERT INTO services(services_name)
VALUES('breakjob1'),
('mufflerfixin'),
('oilchanger')
;

select * from services;


--  create table
CREATE TABLE "sale_invoice" (
  "invoice_num" SERIAL,
  "date_sold" DATE,
  "amount" NUMERIC(10,2),
  "msrp" NUMERIC(10,2),
  "customer_id" INTEGER,
  "vin_id" INTEGER,
  PRIMARY KEY ("invoice_num"),
  FOREIGN KEY(customer_id) REFERENCES customer(customer_id),  
  FOREIGN KEY(vin_id) REFERENCES car(vin_id)  
);

INSERT INTO sale_invoice(date_sold,amount,msrp,customer_id,vin_id)
VALUES('1990-01-01',20000.00,30000.00,1,1),
('1994-05-01',22000.00,30000.00,2,2),
('1990-08-01',24000.00,30000.00,3,3);

select * from sale_invoice;



--  create table
CREATE TABLE "salesperson_invoice" (
  "salesperson_id" INTEGER,
  "invoice_num" INTEGER,
  FOREIGN KEY(salesperson_id) REFERENCES salesperson(salesperson_id),  
  FOREIGN KEY(invoice_num) REFERENCES sale_invoice(invoice_num)  
);

INSERT INTO salesperson_invoice(salesperson_id,invoice_num)
VALUES(1,1),
(2,2),
(3,3);

select * from salesperson_invoice;



--  create table
CREATE TABLE "service_invoice" (
  "invoice_id" SERIAL,
  "date_serviced" DATE,
  "customer_id" INTEGER,
  "part_id" INTEGER,
  "vin_id" INTEGER,
  PRIMARY KEY ("invoice_id"),
  FOREIGN KEY(customer_id) REFERENCES customer(customer_id),  
  FOREIGN KEY(part_id) REFERENCES parts(part_id),  
  FOREIGN KEY(vin_id) REFERENCES car(vin_id) 
);
INSERT INTO service_invoice(date_serviced,customer_id,part_id,vin_id)
VALUES('1998-01-01',1,1,1),
('1999-01-01',1,1,1),
('2000-01-01',1,1,1);

select * from service_invoice;



--  create table

CREATE TABLE "labor" (
  "invoice_id" INTEGER,
  "mechanic_id" INTEGER,
  "services_id" INTEGER,
  "labor_cost" NUMERIC(10,2),
  FOREIGN KEY(invoice_id) REFERENCES service_invoice(invoice_id),  
  FOREIGN KEY(mechanic_id) REFERENCES mechanic(mechanic_id),  
  FOREIGN KEY(services_id) REFERENCES services(services_id) 
);

INSERT INTO labor(invoice_id,mechanic_id,services_id,labor_cost)
VALUES(1,2,2,200),
(2,3,3,300),
(3,1,1,100);

select * from car;
select * from customer;
select * from mechanic;
select * from parts;
select * from sale_invoice;
select * from salesperson;
select * from salesperson_invoice;
select * from service_invoice;
select * from services;
select * from labor;

--  function that adds passed arguments to data table

CREATE OR REPLACE FUNCTION add_customer(_first_name VARCHAR, _last_name VARCHAR, _birth_date DATE, _email VARCHAR)
RETURNS void 
AS $MAIN$
BEGIN
	INSERT INTO customer(first_name, last_name, birth_date, email)
	VALUES(_first_name, _last_name, _birth_date, _email);
END;
$MAIN$
LANGUAGE plpgsql;


SELECT add_customer('Val','Cat', '2000-11-01','whoknows@gmail.com');

select * from customer;


--  function that adds passed arguments to data table

CREATE OR REPLACE FUNCTION add_services(_services_name VARCHAR)
RETURNS void 
AS $MAIN$
BEGIN
	INSERT INTO services(services_name)
	VALUES(_services_name);
END;
$MAIN$
LANGUAGE plpgsql;


SELECT add_services('snow plowing services');

select * from services;


