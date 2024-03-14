DROP SCHEMA IF EXISTS EDWSchemaOgugua;
CREATE SCHEMA EDWSchemaOgugua;
USE EDWSchemaOgugua;

Create table `Effective_Date` (
DateKey int not null auto_increment,
Activity_Date Date not null,
Year_ int not null,
Quarter_ int not null,
Month_ varchar(20) not null,
WeekNo int not null,
key `idx_year` (`Year_`),
key `idx_month` (`Month_`),
key `idx_week` (`WeekNo`),
Primary key (`DateKey`)
)ENGINE=InnoDB AUTO_INCREMENT= 2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `Effective_Date` (DateKey, Activity_Date, Year_, Quarter_, Month_, WeekNo) VALUES
(1, current_date(), year(Activity_Date), QUARTER(Activity_Date), MONTHNAME(Activity_Date), WEEKOFYEAR(Activity_Date))
;

DELIMITER //

CREATE PROCEDURE Date_Dimension(IN iterations INT)
BEGIN
    DECLARE counter INT DEFAULT 0;

    WHILE counter < iterations DO
        INSERT INTO `Effective_Date` (Activity_Date, Year_, Quarter_, Month_, WeekNo)
        SELECT	
			Activity_Date AS Activity_Date, YEAR(Activity_Date), QUARTER(Activity_Date), MONTHNAME(Activity_Date), WEEKOFYEAR(Activity_Date)
		FROM (	SELECT MAX(Activity_Date) + INTERVAL 1 DAY as Activity_Date
				FROM `Effective_Date`) as _date;
        SET counter = counter + 1;
    END WHILE;
    
END //

DELIMITER ;

CALL Date_Dimension(10);