/* 
1.	Shown above is an CERD diagram for Vacation Property Rentals. 
	This organization rents preferred properties in several states/provinces. 
	As shown in the figure, there are two basic types of properties: beach properties and mountain properties. 
	I have provided the DBDL in the next page. 
	Implement the DBDL in MySQL. 
	Write database definition statements in MySQL for each of the relations shown. 
	Ensure you have the appropriate PK and FK constraints. 
	Write MySQL INSERT commands to insert at least 5 records to the RENTER, PROPERTY tables. 
	In the RENTAL AGREEMENT tables INSERT at least 15 records. 
	INSERT the appropriate records in the subtypes, Activity and the propertyActivity tables. 
	Save your work in RentalPropertyYourLastName.sql (13 points)

2.	Generate the MySQL EER diagram using the reverse engineering utility. 
	Save the EER in a file EERRentalPropertyYourLastName. (2 points)

3. 	Suggest an integrity constraint that would ensure that no property is rented twice during the same time interval. 
	Implement this constraint in MySQL? When checking for the constraint provide an error message if the constraint is violated. 
	Save your work in RentalPropertyYourFirstLastName.sql. (5 points)
*/

-- Creating the database
DROP DATABASE IF EXISTS `RentalPropertyOgugua`;
CREATE DATABASE `RentalPropertyOgugua`;
USE `RentalPropertyOgugua`;

-- Create the RENTER table
CREATE TABLE RENTER (
Renter_ID INT AUTO_INCREMENT,
Last_Name VARCHAR(50) NOT NULL,
First_Name VARCHAR(50) NOT NULL,
Middle_Initial VARCHAR(1),
Address VARCHAR(75) NULL,
City VARCHAR(50) NULL,
State VARCHAR(50) NULL,
Phone_No VARCHAR(11) NOT NULL,
Email VARCHAR(255),
CONSTRAINT `pk_Renter` PRIMARY KEY (Renter_ID)
)ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Create the PROPERTY table
CREATE TABLE PROPERTY (
    Property_ID INT AUTO_INCREMENT,
    Street_Address VARCHAR(50) NOT NULL,
    City_State VARCHAR(50) NOT NULL,
    Zip VARCHAR(10) NOT NULL,
    Number_Rooms INT NOT NULL,
    Base_Rate DEC(7, 2) NOT NULL,
    Property_Type CHAR(1),
    CONSTRAINT `pk_Property` PRIMARY KEY (Property_ID),
    CONSTRAINT `Property_type` CHECK(Property_Type IN ('B', 'M', 'R'))
)ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Create the RENTAL_AGREEMENT table
CREATE TABLE RENTAL_AGREEMENT (
    Agreement_ID INT AUTO_INCREMENT,
    Renter_ID INT NOT NULL,
    Property_ID INT NOT NULL,
    Start_Date DATE DEFAULT (CURRENT_DATE()),
    End_Date DATE,
    Rental_Amount DEC(7,2) NOT NULL,
    CONSTRAINT `pk_Rental_Agreement` PRIMARY KEY (Agreement_ID),
    KEY `fk_rental_agreement_renters_idx` (`Renter_ID`),
    KEY `fk_rental_agreement_properties_idx` (`Property_ID`),
    CONSTRAINT `fk_Renter_ID` FOREIGN KEY (`Renter_ID`) REFERENCES RENTER(`Renter_ID`),
    CONSTRAINT `fk_Property_ID` FOREIGN KEY (`Property_ID`) REFERENCES PROPERTY(`Property_ID`),
    CONSTRAINT `date_range` CHECK (Start_Date <= End_Date)
)ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Create the BEACH_PROPERTY table
CREATE TABLE BEACH_PROPERTY (
    BProperty_ID INT NOT NULL,
    Blocks_To_Beach INT,
    KEY `beach_property_idx` (`BProperty_ID`),
    CONSTRAINT `fk_Block_Property` FOREIGN KEY (`BProperty_ID`) REFERENCES PROPERTY(`Property_ID`)
);

-- Create the MOUNTAIN_PROPERTY table
CREATE TABLE MOUNTAIN_PROPERTY (
    MProperty_ID INT NOT NULL,
    KEY `mountain_property_idx` (`MProperty_ID`),
    CONSTRAINT `fk_Mountain_Property` FOREIGN KEY (`MProperty_ID`) REFERENCES PROPERTY(`Property_ID`)
);

-- Create the ACTIVITY table
CREATE TABLE ACTIVITY (
    Activity_ID INT AUTO_INCREMENT,
    Activity_Desc VARCHAR(255) NOT NULL,
    CONSTRAINT `pk_activity` PRIMARY KEY (Activity_ID)
)ENGINE=InnoDB AUTO_INCREMENT=106 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Create the PROPERTY_ACTIVITY table
CREATE TABLE PROPERTY_ACTIVITY (
    MProperty_ID INT NOT NULL,
    Activity_ID INT NOT NULL,
    CONSTRAINT `pk_Property_activity` PRIMARY KEY (MProperty_ID, Activity_ID),
    KEY `fk_property_activity_mountain_idx` (`MProperty_ID`),
    KEY `fk_property_activity_idx` (`Activity_ID`),
    CONSTRAINT `fk_Property_type` FOREIGN KEY (MProperty_ID) REFERENCES MOUNTAIN_PROPERTY(MProperty_ID),
    CONSTRAINT `fk_Activity` FOREIGN KEY (Activity_ID) REFERENCES ACTIVITY(Activity_ID)
);

-- Insert records in RENTER and PROPERTY tables
INSERT INTO RENTER (Renter_ID, Last_Name, First_Name, Middle_Initial, Address, City, State, Phone_No, Email) VALUES
(10, 'Bassey', 'Joel', 'B', '1043 Beverley Lane', 'Guzape', 'FCT', 08022565456, 'bassey.joel@gmail.com'),
(11, 'Henry', 'Duke', 'K', '15 Guanah Avenue', 'Wuse', 'FCT', 08023454328, 'henry.duke@gmail.com'),
(12, 'Dorothy', 'Bachor', 'L', '43 Pinecrest Estate', 'Ikeja', 'Lagos', 08035163694, 'dorothy.bachor@gmail.com'),
(13, 'Nelson', 'Mandela', 'H', '102 Boring Avenue', 'Ikoyi', 'Lagos', 08144856815, 'nelson.mandela@gmail.com'),
(14, 'John', 'Doe', 'T', '7 Sitting Home Lane', 'Yaba', 'Lagos', 08026980648, 'john.doe@gmail.com'),
(15, 'Jane', 'Doe', 'G', '87 Treaty Street', 'Lekki', 'Lagos', 09034633066, 'jane.doe@gmail.com'),
(22, 'Mary', 'Hoppins', 'S', '987 Suncity Estate', 'Victoria Island', 'Lagos', 08161759413, 'mary.hoppins@gmail.com'),
(16, 'Gold', 'Benedict', 'U', '14 Maccido Royal Estate', 'Ijebu', 'Lagos', 07094941611, 'gold.benedict@gmail.com'),
(17, 'Joy', 'Oliver', 'C', '3 Aldenco Estate', 'Surulere', 'Lagos', 08097960902, 'joy.oliver@gmail.com'),
(18, 'Neymar', 'Red', 'A', '1098 Banana Island', 'Wuye', 'FCT', 09077036264, 'neymar.red@gmail.com'),
(19, 'Hello', 'Motto', 'R', '156 Bellview Estate', 'Kado', 'FCT', 09169554369, 'yvonne.chakachaka@gmail.com'),
(20, 'Yvonne', 'Chakachaka', 'Y', '42 City Center', 'Gwarinpa', 'FCT', 08036235996, 'bassey.joel@gmail.com'),
(21, 'Angela', 'Bloom', 'I', '123 Airport Road', 'Lugbe', 'FCT', 08061529170, 'angela.bloom@gmail.com')
;

INSERT INTO PROPERTY (Property_ID, Street_Address, City_State, Zip, Number_Rooms, Base_Rate, Property_Type) VALUES
(1, '134 South Park Street', 'Lagos', '330675', 14, 1226.90, 'B'),
(2, '133 Hamilton Way', 'FCT', '153123', 85, 3515.70, 'B'),
(3, '488 South Street', 'Lagos', '148433', 83, 3627.95, 'M'),
(4, '308 Table Drive', 'FCT', '244468', 20, 1974.18, 'R'),
(5, '244 Citizens Avenue', 'Lagos', '348701', 89, 3799.90, 'R'),
(6, '13 River Parklane', 'FCT', '382681', 63, 2452.24, 'B'),
(7, '69 Nowhere Near', 'Lagos', '137787', 81, 2065.68, 'M'),
(8, '91 Robie Street', 'FCT', '252147', 79, 1707.58, 'M'),
(9, '378 Sobeys Lane', 'Lagos', '362634', 43, 2467.86, 'B'),
(10, '197 Guthro Way', 'FCT', '205391', 4, 2850.74, 'R')
;

-- Insert at least 15 records in RENTAL_AGREEMENT table
INSERT INTO RENTAL_AGREEMENT (Agreement_ID, Renter_ID, Property_ID, Start_Date, End_Date, Rental_Amount) VALUES
(1, 17, 10, '2018-03-26', '2023-01-30', 1912.06),
(2, 13, 7, '2020-12-01', '2022-07-01', 2186.66),
(3, 20, 6, '2020-07-25', '2022-04-16', 1191.25),
(4, 17, 4, '2020-07-21', '2021-06-07', 1513.26),
(5, 11, 7, '2018-07-12', '2023-02-15', 2564.12),
(6, 13, 7, '2018-03-27', '2023-01-07', 3008.71),
(7, 15, 4, '2020-06-07', '2022-08-02', 3503.93),
(8, 20, 8, '2018-06-06', '2023-04-14', 1325.37),
(9, 14, 6, '2018-06-11', '2022-08-20', 966.35),
(10, 10, 6, '2019-06-11', '2022-06-28', 2037.7),
(11, 20, 5, '2020-02-16', '2021-12-04', 867.25),
(12, 18, 5, '2018-01-09', '2022-06-10', 3412.15),
(13, 14, 4, '2020-11-17', '2023-02-23', 1097.43),
(14, 14, 10, '2018-04-02', '2022-11-29', 1966),
(15, 10, 4, '2019-02-17', '2021-12-25', 1442.43),
(16, 12, 2, '2019-03-28', '2022-05-22', 954.71),
(17, 10, 3, '2020-07-04', '2023-10-02', 1423.2),
(18, 10, 5, '2019-03-03', '2023-07-03', 1083.67),
(19, 16, 5, '2020-10-25', '2023-07-30', 2907.41),
(20, 21, 2, '2018-06-29', '2022-01-17', 1569.73),
(21, 10, 1, '2019-12-15', '2023-11-06', 3388.9),
(22, 11, 8, '2018-04-18', '2021-08-07', 2907.73)
;

INSERT INTO BEACH_PROPERTY (BProperty_ID, Blocks_To_Beach) VALUES
(1, 5),
(2, 8),
(6, 2),
(9, 4)
;

INSERT INTO MOUNTAIN_PROPERTY (MProperty_ID) VALUES
(3),
(7),
(8)
;

-- Insert records into Activity and propertyActivity tables
INSERT INTO ACTIVITY (Activity_ID, Activity_Desc) VALUES
(100, 'Swimming'),
(101, 'Hiking'),
(102, 'Sky_Diving'),
(103, 'Yoga'),
(104, 'Spinning'),
(105, 'Movies')
;

INSERT INTO PROPERTY_ACTIVITY (MProperty_ID, Activity_ID) VALUES
(3, 100),
(7, 101),
(8, 100),
(3, 102),
(8, 105),
(7, 103),
(7, 104),
(3, 101)
;