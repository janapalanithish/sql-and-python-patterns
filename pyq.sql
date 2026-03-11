-- creating a database and applying operation like drop on the table 

CREATE DATABASE emplyee;

USE emplyee;

CREATE TABLE inf(
id INT PRIMARY KEY,
user_name VARCHAR(50),
department VARCHAR(50),
salary int);

INSERT INTO inf(id , user_name , department , salary)
VALUES 
(1 , 'nithish' , 'ece' , 1000),
(2 , 'karthik' , 'CSE' , 1234567),
(3 , 'tanush' , 'IT' ,  2345),
(4 , 'sandeep' , 'IT' , 23454);

DROP TABLE inf;
SELECT * FROM inf;
DROP DATABASE emplyee;

SHOW WARNINGS;
-- question2: increment the salary of IT department people of 1000 and delete record where id is 4 and at final delet entire table

SET SQL_SAFE_UPDATES = 0;

UPDATE inf
SET salary = salary + 1000
WHERE department = 'IT';

DELETE inf
FROM inf
WHERE id = 4;

SELECT * FROM inf;

DROP TABLE inf;
-- question3: creating a new table and count the number of IT department people are there in the table using count function
CREATE TABLE inf1(
id INT PRIMARY KEY,
department VARCHAR(50),
salary int
);
INSERT INTO inf1(id , department , salary)
VALUES 
(1 , 'ECE' , 123456),
(2 , 'IT' , 234567),
(3 , 'IT' ,23456),
(4 , 'EEE' , 76543),
(5 , 'CSE' , 765432),
(6 , 'IT' , 8765432);

SELECT * FROM inf1;

SELECT count(*) FROM inf1
WHERE department = 'IT';

-- question4: to get the table of empoloyees who has the startting letter with 'A'
-- we can simply do this question by using like oprator in the example we are getting name starts with k from the inf table

SELECT user_name FROM inf
WHERE user_name LIKE 'k%';

-- like opartor which is best to use which matches the first letter and the remaining letters are unknown
SELECT user_name FROM inf
WHERE user_name LIKE 'n______%';

-- question5: select differnt values of salary from the table 

SELECT distinct salary
FROM inf;

UPDATE inf
SET salary = 1000
WHERE user_name = 'sandeep';

-- question6: finding the 2nd higehest salary using the subqueries and order by clause(also using limit method)

SELECT   salary AS max_sal
FROM inf 
ORDER BY max_sal DESC LIMIT 1,1;

SELECT MAX(salary)
FROM inf
WHERE salary <> (SELECT MAX(salary) 
FROM inf);

-- question7: finding the nth highest salary which includes updating of a value

SELECT distinct salary AS all_sal
FROM inf
ORDER BY all_sal DESC LIMIT 2,1;

-- question8: To get top 2 salaries from the table(inf)
SELECT salary AS is_sal
FROM inf
ORDER BY is_sal DESC LIMIT 2;

-- question9: To get the average and the sum of the values in the table

SELECT AVG(salary) AS avg_sal  , sum(salary) AS sum_sal
FROM inf
GROUP BY department , salary ;

-- question10: write the query for the null value in the department

SELECT * FROM inf
WHERE department = NULL ;
-- as i've not given any null value in the table it returns null in the output table

-- question11: write a query to find the duplicate rows in the employee of the column department

SELECT count(*),department 
FROM inf
GROUP BY department
HAVING count(*) > 1

-- question12: write a query to get emails in a table each once even if they occurred two times in the table
DELETE p1 
FROM Person P1
JOIN Person p2 
ON p1.email = p2.email
AND p1.id > p2.id;
















