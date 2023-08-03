# SET2

## 1. selecting all employees in department 10 whose salary is greater than 3000

use assignment;

select *
	from employee
		where salary > 3000
        AND deptno = 10;

#2. The grading of students based on the marks they have obtained is done as to the questions:

select *,
	   CASE
			WHEN marks BETWEEN 40 AND 49.99 THEN 'Third Class'
            WHEN marks BETWEEN 50 AND 59.99 THEN 'First Class'
            WHEN marks BETWEEN 60 AND 79.99 THEN 'Second Class'
            WHEN marks BETWEEN 80 AND 100 THEN 'Distinction'
            ELSE 'Failed'
		END as Grade        
	from students;
    
#a. How many students have graduated with first class?

ALTER TABLE students
	ADD COLUMN Grade varchar(20) after marks;

describe students;

UPDATE students
	SET Grade = 
	   CASE
			WHEN marks BETWEEN 40 AND 49.99 THEN 'Third Class'
            WHEN marks BETWEEN 50 AND 59.99 THEN 'First Class'
            WHEN marks BETWEEN 60 AND 79.99 THEN 'Second Class'
            WHEN marks BETWEEN 80 AND 100 THEN 'Distinction'
            ELSE 'Failed'
		END;
        
select count(Grade) as 'Students graduated with First Class'
	from students
		where Grade regexp 'First';

# b. How many students have obtained distinction?

select count(Grade) as 'Students graduated with Distinction'
	from students
		where Grade regexp 'Dist';
        
# 3. Get a list of city names from station with even ID numbers only. Exclude duplicates from your answer

select *  
	from station
		where id % 2 = 0;

select *,
       COUNT(*) as CNT	  
	from station
		where id % 2 = 0
			GROUP BY id, city, state, lat_n, long_w
				HAVING CNT = 1;

select *	  
	from station
		where id % 2 = 0
			GROUP BY id, city, state, lat_n, long_w
				HAVING COUNT(*) = 1;
	
# 4. Find the difference between the total number of city entries in the table and the number of distinct city entries in the table.
# In other words, if N is the number of city entries in station, and N1 is the number of distinct city names in station, 
# write a query to find the value of N-N1 from station

select count(city) as 'Count of all Cities'
	from station;

select count(distinct city) as 'Count of Distinct Cities'
	from station;
    
select count(city) - count( distinct city) as 'Difference Between Number of Distinct and All Cities'
	from station;
    
## 5. Answer the following
 #a

select city
	FROM station
		where city regexp '^a|^e|^i|^o|^u'
			GROUP BY city
				order by city;

#b
select city
	FROM station
		where city regexp '^a|^e|^i|^o|^u' AND
              city regexp 'a$|e$|i$|o$|u$'
			GROUP BY city
				order by city;
                
#c
select city
	FROM station
		where city Not regexp '^a|^e|^i|^o|^u'
			GROUP BY city
				order by city;
			
#d
select city
	FROM station
		where city not regexp '^a|^e|^i|^o|^u' AND
              city not regexp 'a$|e$|i$|o$|u$'
			GROUP BY city
				order by city;

# 6. Write a query that prints a list of employee names having a salary greater than $2000 per month who have been employed for less than 36 months. Sort your result by descending order of salary.

select Concat(first_name, ' ', last_name) as Employee,
       Concat(salary, '$') as 'Salary($)',
       hire_date,
      timestampdiff(MONTH, hire_date, current_date()) as 'Total_Months_Joined'
	from emp
		where salary > 2000
			having Total_Months_Joined < 36
				order by salary desc;

# 7. How much money does the company spend every month on salaries for each department?



select deptno,
	   sum(salary) as Total_salary
	from employee
		group by deptno;
        
# 8. How many cities in the CITY table have a Population larger than 100000. 

select name as City,
	   population
	from city
		where population > 100000
			order by population desc;
            
## 9. What is the total population of California

select district,
       sum(population) as Total_population
	from city
		where district regexp 'California'
			group by district;
            
## 10. What is the average population of the districts in each country

select district as District,
       AVG(population) as Average_Population
	from city
		group by District;
        
## 11. Find the ordernumber, status, customernumber, customername and comments for all orders that are ‘Disputed=

select o.ordernumber, 
       o.status, 
       o.customernumber, 
       c.customername, 
       o.comments
	from customers c 
		JOIN orders o
			USING (customernumber)
				Where o.status = 'Disputed';