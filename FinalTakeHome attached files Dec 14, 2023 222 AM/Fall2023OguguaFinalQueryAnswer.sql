-- Fill in the appropriate DB name below 
USE FinalMySQL;

-- Hint: USE JOIN, LEFT JOIN, self join,  GROUP BY, subquery, some multi-table, WHERE, IN clause, subquery using a GROUP BY, 
-- HAVING clause, correlated query, CASE, derived tables and other techniques learnt in class 

-- Query1: For Each salesperson, show the number of orders placed for each month of 2017. 
-- Show the SalespersonID, monthofOrder and the number of orders for that month. Sort by SalesPersonID and then by Month 
SELECT o.SalespersonID, monthname(o.OrderDate) As monthofOrder, SUM(ol.OrderedQuantity) As Total_Order
FROM `order_t` AS o
LEFT JOIN `orderline_t` AS ol
ON o.OrderID = ol.OrderID
WHERE YEAR(o.OrderDate) = 2017
GROUP BY o.SalespersonID, monthname(o.OrderDate)
ORDER BY o.SalespersonID, monthname(o.OrderDate)
;

-- Query2: Show OrderID, CustomerID, CustomerName, OrderDate for the all orders in the month of September, 2018:
SELECT o.OrderID, c.CustomerID, c.CustomerName, o.OrderDate
FROM `order_t` AS o
LEFT JOIN `customer_t` AS c
ON o.CustomerID = c.CustomerID
WHERE YEAR(o.OrderDate) = 2018 AND MONTHNAME(o.OrderDate) = 'September'
; 
 
-- Query3: Show ProductID, ProductDescription, ProductFinish, and ProductStandardPrice for oak products 
-- with price of atleast 400 or cherry products with price less than 300:
SELECT ProductID, ProductDescription, ProductFinish, ProductStandardPrice
FROM `product_t`
WHERE (ProductFinish = 'Oak' AND ProductStandardPrice >= 400)
OR (ProductFinish = 'Cherry' AND ProductStandardPrice < 300)
;

-- Query4: Display the customer ID, name, and count of orderID for all customer with orders. For those customers 
-- who do not have any orders the count will display 0:       
SELECT c.CustomerID, c.CustomerName, COUNT(o.OrderID)
FROM `customer_t` AS c
LEFT JOIN `order_t` AS o
ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID
; 

-- Query5: Show the customer ID and name for all the customers who have ordered both products with IDs 3 and 4 
-- on the same order:
/* SELECT c.CustomerID, c.CustomerName, ol.ProductID, o.OrderID, o.OrderDAte
FROM `customer_t` AS c
JOIN `order_t` AS o 
	ON c.CustomerID = o.CustomerID
JOIN `orderline_t` AS ol 
	ON o.OrderID = ol.OrderID
WHERE ol.ProductID = 4 AND ol.OrderID IN (	SELECT OrderID
											FROM `orderline_t`
                                            WHERE productID = 3)
;	
*/ 
SELECT c.CustomerID, c.CustomerName
FROM `customer_t` AS c
LEFT JOIN `order_t` AS o 
	ON c.CustomerID = o.CustomerID
LEFT JOIN `orderline_t` AS ol 
	ON o.OrderID = ol.OrderID
WHERE ol.ProductID = 4 AND ol.OrderID IN (	SELECT OrderID
											FROM `orderline_t`
                                            WHERE productID = 3)
;

-- Query6: List vendor ID, vendor name, material ID, material name, and supply unit price 
-- for those materials that are provided by more than one vendor:
SELECT v.VendorID, v.VendorName, r.MaterialID, r.MaterialName, s.SupplyUnitPrice
FROM `supplies_t` as s
JOIN `rawmaterial_t` as r
	ON s.MaterialID = r.MaterialID
JOIN `vendor_t` as v
	ON s.VendorID = v.VendorID
WHERE r.MaterialID IN (	SELECT MaterialID
						FROM FinalMySQL.supplies_t
                        GROUP BY MaterialID
                        HAVING count(DISTINCT(VendorID)) >1)

;

/*
SELECT v.VendorID, v.VendorName, r.MaterialID, r.MaterialName, s.SupplyUnitPrice
FROM `rawmaterial_t` as r
JOIN `supplies_t` as s
	ON r.MaterialID = s.MaterialID
JOIN `vendor_t` as v
	ON s.VendorID = v.VendorID 
WHERE r.MaterialID IN (	SELECT MaterialID
						FROM FinalMySQL.supplies_t
                        group by MaterialID
                        having count(distinct(VendorID)) >1)
;
*/

--  Query7: List the IDs and description of all products that cost less than the average 
-- product price in their product line
SELECT ProductID, ProductDescription
FROM `product_t` as p
WHERE ProductStandardPrice < (	SELECT AVG(ProductStandardPrice)
								FROM product_t
								WHERE ProductLineID = p.ProductLineID)
;

-- 	Query8: Create a VIEW called BestCompDeskSalesPerson that lists the salesperson (their ID, and Name) 
-- that has sold the most computer desks:
CREATE VIEW BestCompDeskSalesPerson AS
SELECT BCDSP_t.SalespersonID, BCDSP_t.SalespersonName
FROM (	SELECT s.SalespersonID, s.SalespersonName, sum(ol.OrderedQuantity) as total_comp_desk_sold
		FROM `salesperson_t` as s
		LEFT JOIN `order_t` as o
			ON s.SalespersonID = o.SalespersonID
		LEFT JOIN `orderline_t` as ol
			ON o.OrderID = ol.OrderID
		LEFT JOIN `product_t` as p 
			ON ol.ProductID = p.ProductID
		WHERE
			p.ProductDescription LIKE ('%computer desk%')
		GROUP BY s.SalespersonID, s.SalespersonName
		ORDER BY total_comp_desk_sold desc
		LIMIT 1) as BCDSP_t
	;

-- Query9:	List the Employee information for all employees in each state who were hired 
-- before the most recently hired person in that state
SELECT *
FROM `employee_t` as e
WHERE EmployeeDateHired < (	SELECT max(EmployeeDateHired)
							FROM employee_t
							WHERE EmployeeState = e.EmployeeState)
;
     
-- Query10: Create a CASE query for data from the RawMaterial_t table 
-- List the MaterialID, MaterialName, Material, MaterialStandardPrice for every MaterialName together 
-- with the AVERAGE MaterialStandardPrice for its Material (e.g., Ash, Birch, Cherry, Oak...) 

-- SHOW THE DISTINCT MATERIALS
SELECT DISTINCT Material 
FROM `rawmaterial_t`;

-- USE THE MATERIALS TO RUN THE CASE QUERY NOT INCLUDING THE BLANKS
-- THE BLANKS ARE COVERED IN THE ELSE STATEMENT BECAUSE THEY MIGHT NOT ALL BE OF THE SAME MATERIAL
SELECT MaterialID, MaterialName, Material, MaterialStandardPrice,
CASE
    WHEN Material = 'Ash' THEN (SELECT AVG(MaterialStandardPrice) FROM `rawmaterial_t` WHERE Material = 'Ash' )
    WHEN Material = 'Birch' THEN (SELECT AVG(MaterialStandardPrice) FROM `rawmaterial_t` WHERE Material = 'Birch' )
    WHEN Material = 'Cherry' THEN (SELECT AVG(MaterialStandardPrice) FROM `rawmaterial_t` WHERE Material = 'Cherry' )
    WHEN Material = 'Mahogany' THEN (SELECT AVG(MaterialStandardPrice) FROM `rawmaterial_t` WHERE Material = 'Mahogany' )
    WHEN Material = 'Oak' THEN (SELECT AVG(MaterialStandardPrice) FROM `rawmaterial_t` WHERE Material = 'Oak' )
    WHEN Material = 'Pine' THEN (SELECT AVG(MaterialStandardPrice) FROM `rawmaterial_t` WHERE Material = 'Pine' )
    WHEN Material = 'Walnut' THEN (SELECT AVG(MaterialStandardPrice) FROM `rawmaterial_t` WHERE Material = 'Walnut' )
	WHEN Material = 'Upholstery Adhe' THEN (SELECT AVG(MaterialStandardPrice) FROM `rawmaterial_t` WHERE Material = 'Upholstery Adhe' )
    WHEN Material = 'Wood Adhesive' THEN (SELECT AVG(MaterialStandardPrice) FROM `rawmaterial_t` WHERE Material = 'Wood Adhesive' )
    WHEN Material = 'Urethane Finish' THEN (SELECT AVG(MaterialStandardPrice) FROM `rawmaterial_t` WHERE Material = 'Urethane Finish' )
    WHEN Material = 'Labor' THEN (SELECT AVG(MaterialStandardPrice) FROM `rawmaterial_t` WHERE Material = 'Labor' )
    WHEN Material = 'Common Nail' THEN (SELECT AVG(MaterialStandardPrice) FROM `rawmaterial_t` WHERE Material = 'Common Nail' )
    WHEN Material = 'Finish Nail' THEN (SELECT AVG(MaterialStandardPrice) FROM `rawmaterial_t` WHERE Material = 'Finish Nail' )
    WHEN Material = 'Oval Wire Nail' THEN (SELECT AVG(MaterialStandardPrice) FROM `rawmaterial_t` WHERE Material = 'Oval Wire Nail' )
    WHEN Material = 'Staples' THEN (SELECT AVG(MaterialStandardPrice) FROM `rawmaterial_t` WHERE Material = 'Staples' )
    WHEN Material = 'Upholstery Tack' THEN (SELECT AVG(MaterialStandardPrice) FROM `rawmaterial_t` WHERE Material = 'Upholstery Tack' )
    ELSE (SELECT AVG(MaterialStandardPrice) FROM rawmaterial_t  )
END AS MaterialStandardPrice
FROM `rawmaterial_t`
ORDER BY Material;

-- Query11:	Create a procedure to to find customers who have not placed any orders. Show the CustomerId, CustomerName.
-- Call the procedure NoShowCustomer. Include code to invoke this procedure. 
DROP PROCEDURE IF EXISTS `NoShowCustomer`;

DELIMITER //
CREATE procedure NoShowCustomer()
BEGIN 
SELECT c.CustomerID, c.CustomerName
FROM `customer_t` as c
LEFT JOIN `order_t` as o
ON c.CustomerID = o.CustomerID
WHERE c.CustomerID NOT IN (	SELECT DISTINCT(CustomerID)
							FROM `order_t`
                            )	
ORDER BY c.CustomerID
;
END //
DELIMITER ;

CALL NoShowCustomer ()
;
        
-- Question 12: Create a trigger that when updating the MaterialStandardPrice of any materialName in the RAWMATERIAL_t table 
-- creates an audit trail to store the previous price. Include the update code that will cause this trigger to fire. 
CREATE TABLE rawmaterial_t_audit (
Audit_ID INT AUTO_INCREMENT PRIMARY KEY,
Material_ID VARCHAR(50) NOT NULL, 
Material_Name VARCHAR(255) NOT NULL,
Old_Price DEC(5,2),
Change_Time DATETIME DEFAULT NULL, 
Activity VARCHAR(50) DEFAULT NULL
);

CREATE TRIGGER before_material_price_update
BEFORE UPDATE ON rawmaterial_t
FOR EACH ROW
INSERT INTO rawmaterial_t_audit
SET Activity = 'Update',
Material_ID = OLD.MaterialID,
Material_Name = OLD.MaterialName,
Old_Price = OLD.MaterialStandardPrice,
Change_Time = NOW()
;

UPDATE `rawmaterial_t`
SET MaterialStandardPrice = 70.50
WHERE MaterialID = '1-1/21010ASH'
;

/*
SET SQL_SAFE_UPDATES = 0;

UPDATE `rawmaterial_t` 
SET MaterialStandardPrice = 70.50 
WHERE MaterialName = '1-1/2in X 10in X 10ft  Birch'
*/

-- Question 13: create a function that returns the Material Class (Superior, Good, Standard) based on their thickness and Width.
-- Thickness 1 1/2 and width 10 and 12 is Superior, Thickness 1/2 and width 8 and above is Good, All others are standard
-- Include the code to call this function

-- I will be assuming that the question says that for a material to be considered superior, the width should be
-- either 10 or 12 while its thickness should be 1 1/2 but an item possessing any of these qualities, is still considered superior.
-- Also, a good material is one whose thickness is 1/2 or its width is 8 and above 

DELIMITER //

CREATE FUNCTION Material_Class (Thickness VARCHAR(50), Width VARCHAR(50))

RETURNS VARCHAR(50)

DETERMINISTIC

BEGIN
DECLARE Material_Class VARCHAR(50);
IF Thickness = '1-1/2' OR Width = '10' OR Width = '12' THEN
	SET Material_Class = 'Superior';
ELSEIF (Thickness = '1/2') OR (Width >= '8') THEN
	SET Material_Class = 'Good';
ELSE
	SET Material_Class = 'Standard';
END IF;

RETURN (Material_Class);

END //

DELIMITER ;

/*
SELECT *, Material_Class(Thickness, Width) AS M_Class
FROM `rawmaterial_t`
*/

SELECT MaterialID, MaterialName, Thickness, Width, Material_Class(Thickness, Width) AS M_Class
FROM `rawmaterial_t`
ORDER BY M_Class, Thickness, Width
;

-- Question 14: I have created an empty Faculty table. Use the START TRANSACTION to INSERT 5 records in the faculty table. 
-- Include COMMIT and ROLLBACK in the appropriate places to demonstrate that a ROLLBACK executed before a COMMIT will
-- abort the transaction. Comment out the rollback. Use COMMIT to demonstrate that the INSERTS are permanent.
DROP TABLE IF EXISTS `Faculty`;
CREATE TABLE `Faculty` (
    Faculty_ID INT PRIMARY KEY AUTO_INCREMENT,
    Faculty_Name VARCHAR(50),
    Floors VARCHAR(3)
);

SET autocommit = 0;

START TRANSACTION;

INSERT INTO `Faculty` (Faculty_ID, Faculty_Name, Floors) values
(1, 'Research and Development', 3),
(2, 'Product Management', 3),
(3, 'Engineering', 3),
(4, 'Business Development', 4),
(5, 'Engineering', 6);

-- ROLLBACK;

COMMIT;
