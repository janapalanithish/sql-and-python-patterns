-- nth highest salary
CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
  DECLARE M INT;
  SET M = N - 1; 
  RETURN (
      SELECT DISTINCT salary
      FROM Employee
      ORDER BY salary DESC
      LIMIT M, 1
  );
END

-- 2nd highest salary
-- we used subquery because the normal query fails at distinct and no indices case so to fix this we've used subquery
SELECT 
    (SELECT DISTINCT salary 
     FROM Employee
     ORDER BY salary DESC
     LIMIT 1, 1) AS SecondHighestSalary;

-- rank according to the scores
SELECT 
    score,
    DENSE_RANK() OVER (ORDER BY score DESC) AS `rank`
FROM Scores
ORDER BY score DESC;


-- for which employees earn more than their managers
SELECT e1.name as Employee
FROM Employee e1
LEFT JOIN Employee e2
ON e1.managerId = e2.id
WHERE e1.salary > e2.salary;

-- from the table selecting the number which are occuring more than three times 
SELECT num AS ConsecutiveNums 
FROM Logs
GROUP BY ConsecutiveNums 
HAVING count(num) > 3;

-- with differnet type of solution 
SELECT DISTINCT l1.num AS ConsecutiveNums
FROM Logs l1
JOIN Logs l2 ON l2.id = l1.id + 1
JOIN Logs l3 ON l3.id = l1.id + 2
WHERE l1.num = l2.num
  AND l2.num = l3.num;

-- duplicating email if the email occurs more than once
SELECT email 
FROM person 
GROUP BY email 
having count(email) > 1

-- write a query to get emails in a table each once even if they occurred two times in the table
DELETE p1 
FROM Person P1
JOIN Person p2 
ON p1.email = p2.email
AND p1.id > p2.id;

-- finding the person who never orders 

# Write your MySQL query statement below
SELECT name AS Customers
FROM Customers AS i1
LEFT JOIN Orders AS i2
ON i1.id = i2.CustomerId
WHERE CustomerId is NULL;


-- finding maxium salary of the department with two differnt tables and joining the id and departmentId
SELECT d1.name AS Department ,
       e1.name AS Employee ,
       e1.salary AS Salary
FROM Employee AS e1
JOIN Department AS d1
ON e1.departmentId = d1.id 
WHERE e1.salary = (
    SELECT MAX(salary)
    FROM Employee
    WHERE departmentId = e1.departmentId
)
