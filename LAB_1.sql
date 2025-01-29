use ap;
# 1
SELECT * FROM vendors ORDER BY vendor_id;

# 2
SELECT vendor_name, vendor_phone, vendor_city
FROM vendors 
WHERE vendor_state = 'CA' 
ORDER BY vendor_name;
    
# 3
SELECT invoice_id, invoice_total, invoice_date 
FROM invoices 
ORDER BY invoice_total DESC;
# 4 
SELECT invoice_id, invoice_total
FROM invoices 
ORDER BY invoice_total
LIMIT 3, 6;

#5
SELECT invoice_id, invoice_total, invoice_total - payment_total AS "Remaining Balance" 
FROM invoices 
ORDER BY invoice_id;
    
#6
SELECT invoice_id, invoice_total, vendor_name, vendor_phone 
FROM vendors INNER JOIN invoices
	ON vendors.vendor_id = invoices.vendor_id
ORDER BY invoice_id;

#7
SELECT invoice_id, invoice_total, vendor_name, vendor_phone
FROM vendors LEFT JOIN invoices
	ON vendors.vendor_id = invoices.vendor_id
ORDER BY vendor_name;

#8 - This one's instructions has the wrong names for the columns and order by
SELECT last_name, department_name
FROM ex.departments RIGHT JOIN ex.employees
	ON ex.departments.department_number= ex.employees.department_number 
ORDER BY departments.department_number;

#9
SELECT CONCAT(first_name,' ' , last_name) as full_name , vendor_name
FROM vendor_contacts JOIN vendors
	ON vendor_contacts.vendor_id = vendors.vendor_id;

#10
SELECT first_name FROM ex.employees
UNION
SELECT rep_first_name FROM ex.sales_reps;

#11
SELECT invoice_id, invoice_total, vendor_name, terms_description
FROM invoices
	LEFT JOIN vendors
		ON invoices.vendor_id = vendors.vendor_id
	LEFT JOIN terms
		ON invoices.terms_id = terms.terms_id
ORDER BY invoice_id
    ;
    
