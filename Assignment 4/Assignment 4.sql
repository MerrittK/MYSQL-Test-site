
USE `ap`;
-- Cleanup
DROP procedure IF EXISTS `get_vendor_invoices`;
DROP procedure IF EXISTS `apply_payment`;
DROP procedure IF EXISTS `insert_new_invoice`;

DELIMITER $$

-- Procedure 1
CREATE PROCEDURE `get_vendor_invoices` (
	in vendor_id_param int unsigned
)
BEGIN
	SELECT invoice_id,invoice_number,invoice_date,invoice_total,payment_total
	FROM `ap`.`invoices`
    WHERE vendor_id = vendor_id_param ;
END$$

-- Procedure 2
--  A cursory glance indicates that credit total isn't actually affiliated with the other variables in a consistant way
-- For some unpaid invoices, credit total is equal to the difference between invoice payments and invoice total 
-- However, a substantial portion of the invoices have zero in the credit total, or evon something unrelated. I don't have a good herustic for when to change credit total and how much by. 
-- So I don't do anything with credit total

CREATE PROCEDURE `apply_payment` (
	in invoice_id_param int,
    in amount_paid_param decimal(9,2)
)
BEGIN 

	-- Using a transaction, because we are both reading and writing an object.
	START TRANSACTION;
    
    -- A select variable assignment, which does the addition of the amount paid now to the payment total
    SELECT  invoice_total, (amount_paid_param + payment_total) INTO @var_invoice_total, @new_payment_total
        FROM invoices
        WHERE invoice_id = invoice_id_param;
    
    -- If the total amount paid is lower or equal to the invoice total, then apply the change and commit.alter
    -- Otherwise, send signal and rollback
    IF @new_payment_total <= @var_invoice_total THEN
        UPDATE invoices
		    SET payment_total = @new_payment_total
		    WHERE invoice_id = invoice_id_param;
        SELECT payment_total, @new_payment_total  from invoices
		    WHERE invoice_id = invoice_id_param;
       Commit;
    ELSE
		SIGNAL SQLSTATE '22003'
			SET MESSAGE_TEXT = 'The invoice payment cannot be above the remaining balance', 
            MYSQL_ERRNO = 1264;
    END IF;
END$$
-- Procedure 3

-- This one is rather simple, thankfully. - Just match the input types, match the outputs, and go for it.
CREATE PROCEDURE `insert_new_invoice` (
	IN vendor_id_param INT, 
    IN invoice_number_param VARCHAR(50), 
    IN invoice_date_param DATE, 
    IN invoice_total_param DECIMAL(9,2), 
    IN terms_id_param INT,
    OUT new_invoice_id INT
)
BEGIN
	INSERT INTO invoices (invoice_id, vendor_id, invoice_number, invoice_date, invoice_total, terms_id, payment_total, credit_total )
	VALUES
    (default, vendor_id_param, invoice_number_param, invoice_date_param, invoice_total_param, terms_id_param,
    0,0);
    SET new_invoice_id = LAST_INSERT_ID(); -- Just snag it after it generates

END$$

DELIMITER ;

