use ap;

-- Question 1
SELECT count(distinct invoice_id) as total_invoices
FROM invoices;

-- Question 2
SELECT sum(invoice_total) as total_invoice_amount
FROM invoices;

-- Question 3
SELECT avg(invoice_total) as average_invoice_total
FROM invoices;

-- Question 4
SELECT 
	max(invoice_total) as highest_invoice_total , 
	min(invoice_total) as lowest_invoice_total
FROM invoices;

-- Question 5
SELECT
	vendor_id,
	sum(invoice_total) as total_amount_paid
FROM invoices
GROUP BY vendor_id
ORDER BY total_amount_paid DESC;

-- Question 6
SELECT
	vendor_id,
    count( distinct invoice_id) as invoice_count,
	sum(invoice_total) as total_amount_paid
FROM invoices
GROUP BY vendor_id
ORDER BY total_amount_paid DESC;

-- Question 7
SELECT g.account_number, sum(line_item_amount) as total_line_item_amount
FROM general_ledger_accounts g  Left Join invoice_line_items l
	ON g.account_number= l.account_number
GROUP BY g.account_number
ORDER BY total_line_item_amount DESC;

-- Question 8
SELECT vendor_id, sum(invoice_total) as total_invoice_amount
FROM invoices
GROUP BY vendor_id WITH ROLLUP
ORDER BY vendor_id ASC
;
