use ap;

-- 1 Selects all from vendors
SELECT * 
FROM vendors 
ORDER BY vendor_id;

-- 2 Selects columns from vendors in CA
SELECT vendor_name, vendor_phone, vendor_city
FROM vendors 
WHERE vendor_state = 'CA' 
ORDER BY vendor_name;
    
-- 3 Gets
SELECT invoice_id, invoice_total, invoice_date 
FROM invoices 
ORDER BY invoice_total DESC;

-- 4  Gets 3rd to 9th items in ascending.
SELECT invoice_id, invoice_total
FROM invoices 
ORDER BY invoice_total ASC -- explicit ASC for clarity
LIMIT 3, 6; -- gets 6 lines after 3, equivilant to getting lines 3-9

-- 5 -Aliases arithmatic operation to "remaining balance"
SELECT invoice_id, invoice_total, 
	invoice_total - payment_total AS "Remaining Balance" 
FROM invoices 
ORDER BY invoice_id;
    
--6
SELECT invoice_id, invoice_total, vendor_name, vendor_phone 
FROM vendors INNER JOIN invoices
	ON vendors.vendor_id = invoices.vendor_id
ORDER BY invoice_id;

--7
SELECT vendor_name, invoice_id
FROM vendors LEFT JOIN invoices --left join gets vendors who do not have linked invoices
	ON vendors.vendor_id = invoices.vendor_id
ORDER BY vendor_name;

--8 the assignment "employee_last_name" doesn't exist, using last_name from ex.employees
SELECT last_name, department_name
FROM ex.employees LEFT JOIN ex.departments
	ON ex.employees.department_number = ex.departments.department_number
ORDER BY departments.department_number;

--9 gets a concatanated fullname as full_name
SELECT CONCAT(first_name,' ' , last_name) as full_name , vendor_name
FROM vendor_contacts INNER JOIN vendors -- we are only interested in cases with a vendor contact
	ON vendor_contacts.vendor_id = vendors.vendor_id;

--10
SELECT first_name FROM ex.employees
UNION --Union gets unique by default.
SELECT rep_first_name FROM ex.sales_reps;

--11
SELECT invoice_id, invoice_total, vendor_name, terms_description
FROM invoices
    INNER JOIN vendors
		ON invoices.vendor_id = vendors.vendor_id --attach everything via invoice.id.
	INNER JOIN terms -- Hypothetically, IG we could have invoices without valid terms or vendors, but that would most
			 --likely be a sign of an error.
		ON invoices.terms_id = terms.terms_id 
ORDER BY invoice_id;
    

    
