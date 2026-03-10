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