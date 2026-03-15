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

-- finding the days where the temperature is greater than the previuos dates
SELECT w2.id AS Id
FROM Weather AS w1
JOIN Weather AS w2
ON w2.recordDate = w1.recordDate + INTERVAL 1 DAY  
WHERE w2.temperature > w1.temperature;

-- finding the first login of the user while palying a game according to the games played 

SELECT player_id , min(event_date) AS first_login 
FROM Activity
GROUP BY player_id;

-- game wise level 4: we need to find the number of palyers are logging in just after the first day after the game and we should return the fraction of total number of users played just after the first day 
SELECT
  ROUND(
    COUNT(A1.player_id)
    / (SELECT COUNT(DISTINCT A3.player_id) FROM Activity A3)
  , 2) AS fraction
FROM
  Activity A1
WHERE
  (A1.player_id, DATE_SUB(A1.event_date, INTERVAL 1 DAY)) IN (
    SELECT
      A2.player_id,
      MIN(A2.event_date)
    FROM
      Activity A2
    GROUP BY
      A2.player_id
  );

-- combining two tables. If the id doesn't exist in the second table, return NULL
SELECT firstName , lastName , city , state 
FROM Person p1
LEFT JOIN Address a1
ON p1.personId = a1.personId;

-- top salary of the table with having two different tables with entire departments
SELECT
    d.name AS Department,
    e.name AS Employee,
    e.salary AS Salary
FROM
    Employee e
    JOIN Department d ON e.departmentId = d.id
WHERE
    (
        SELECT COUNT(DISTINCT salary)
        FROM Employee e2
        WHERE e2.departmentId = e.departmentId AND e2.salary >= e.salary
    ) <= 3
ORDER BY
    Department, Salary DESC;

-- fetching the user nmaes who has bonus of less than 1000 and null from two tables 
SELECT e1.name AS name , 
       b1.bonus AS bonus
FROM Employee AS e1
LEFT JOIN Bonus AS b1
ON e1.empId = b1.empId
WHERE b1.bonus < 1000 
      OR b1.bonus IS NULL;


-- fetching the manager who has atleast five clients from the table 
SELECT e1.name AS name
FROM Employee e1
JOIN Employee e2
ON e1.id = e2.managerId
GROUP BY e1.id
HAVING count(e2.managerId) >= 5;



