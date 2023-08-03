#set 3
use assignment;
SET SQL_SAFE_UPDATES =0;

-- Q1.Write a stored procedure that accepts the month and year as inputs and prints the ordernumber, orderdate and status of the orders placed in that month



delimiter //
CREATE PROCEDURE Order_status (IN in_month INT, IN in_year INT )
BEGIN
SELECT orderNumber, orderDate ,status FROM orders 
WHERE in_month = MONTH("shippeddate") AND in_year = YEAR("shippeddate") ;
END //

CALL Order_status ( 11 , 2005);

#q2,a Write function that takes the customernumber as input and returns the purchase_status based on the following criteria 

##
select *,
     CASE
      WHEN amount < 25000 THEN 'Silver'
      WHEN amount BETWEEN 25000 AND 50000 THEN 'Gold'
            ELSE 'Platinum'
            END AS Status
  from payments;

DELIMITER //

CREATE FUNCTION GetPurchaseStatus(customerNumber INT) RETURNS VARCHAR(255)
BEGIN
  DECLARE purchaseAmount DECIMAL(10, 2);
  DECLARE status VARCHAR(255);

  -- Calculate the total purchase amount for the customer
  SELECT SUM(amount) INTO purchaseAmount
  FROM Payments
  WHERE customerNumber = customerNumber;

  -- Determine the purchase status based on the purchase amount
  IF purchaseAmount < 25000 THEN
    SET status = 'Silver';
  ELSEIF purchaseAmount >= 25000 AND purchaseAmount <= 50000 THEN
    SET status = 'Gold';
  ELSE
    SET status = 'Platinum';
  END IF;

  RETURN status;
END;

#b Write a query that displays customerNumber, customername and purchase_status from customers table

SELECT customerNumber, customername, GetPurchaseStatus(customerNumber) AS purchase_status
FROM customers;

    
    ## qs3 Replicate the functionality of 'on delete cascade' and 'on update cascade' using triggers on movies and rentals tables
    -- Note: Both tables - movies and rentals - don't have primary or foreign keys. Use only triggers to implement the above
    
DELIMITER //
CREATE TRIGGER delete_cascade
  AFTER DELETE on movies
    FOR EACH ROW 
    BEGIN
      UPDATE rentals
        SET movieid = NULL
          WHERE movieid
                       NOT IN
            ( SELECT distinct id
              from movies );
    END //
DELIMITER ;

drop trigger if exists delete_cascade;

select *
  from movies;

INSERT INTO movies ( id,             title,          category )
      Values ( 11, 'The Dark Knight', 'Action/Adventure');

INSERT INTO rentals ( memid, first_name, last_name, movieid ) 
           Values (     9,     'Moin',   'Dalvi',      11 );

delete from movies
  where id = 11;

SELECT id
  from movies;

SELECT *
  from rentals;

DELIMITER //
CREATE TRIGGER update_cascade
  AFTER UPDATE on movies
    FOR EACH ROW 
    BEGIN
      UPDATE rentals
        SET movieid = new.id
          WHERE movieid = old.id;
    END //
DELIMITER ;

DROP trigger if exists update_cascade;

INSERT INTO movies ( id,             title,          category )
      Values ( 12, 'The Dark Knight', 'Action/Adventure'); 

UPDATE rentals
  SET movieid = 12
    WHERE memid = 9;

UPDATE movies
  SET id = 11
    WHERE title regexp 'Dark Knight';

select *
  from movies;

## qs4  Select the first name of the employee who gets the third highest salary(table employee)

select *
  from employee
    order by salary desc
      limit 2,1;
      
      
      ## qs 5 Assign a rank to each employee  based on their salary. The person having the highest salary has rank 1(from table employe)
      
      select *,
     dense_rank () OVER (order by salary desc) as Rank_salary
  from employee;


