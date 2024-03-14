-- setting an integrity constraint for property_id, start_date and end_date
-- this ensures that all the columns do not have the same values for multiple rows
-- However, it does not solve the issue of overlapping dates for a particular property
ALTER TABLE RENTAL_AGREEMENT
ADD CONSTRAINT `unique_rental_constraint` UNIQUE (property_id, start_date, end_date)
;


DELIMITER //

CREATE TRIGGER before_insert_rental_agreement
BEFORE INSERT ON RENTAL_AGREEMENT
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT *
        FROM RENTAL_AGREEMENT
        -- Assuming that a property can be rented on the same day after a previous rent expires
        -- i.e. end day of one agreement can be the same as the start day of another agreement
        WHERE property_id = NEW.property_id
        AND start_date < NEW.end_date
        AND end_date > NEW.start_date
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'This property has already been rented within this period. Kindly select a different date or check property ID';
    END IF;
END //

DELIMITER ;