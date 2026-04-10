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

-- a table has a customer and referral relationship we need to remove the customers who are not referre and with the id 2
SELECT name 
FROM Customers
WHERE referee_id IS NULL
      OR referee_id <> 2;
  

-- customer placing with the highest number with the order number 

SELECT customer_number
FROM Orders
GROUP BY customer_number
ORDER BY count(order_number) DESC 
LIMIT 1;

-- selecting the countries which has either the population greater than 25000000 or area is greater than 3000000

SELECT name , population , area 
FROM World 
WHERE population >= 25000000
    OR area >= 3000000;

-- write a quesry to find the class which has grater than five students 
SELECT class
FROM Courses 
GROUP BY class
HAVING count(class) >= 5;

-- checking the highest number and unique number in the table 
SELECT MAX(num) AS num
FROM MyNumbers
WHERE num IN (
    SELECT num
    FROM MyNumbers
    GROUP BY num
    HAVING count(num) = 1
);

-- fetching movies other than boring description and the odd id number with descending in id , rating of the movie
SELECT id , movie , description , rating 
FROM Cinema 
GROUP BY id , movie , description , rating
HAVING id%2 <> 0 AND description <> "boring"
ORDER BY rating DESC;

-- swapping the gender of the people in a compnay using single update statement
UPDATE Salary SET sex =
CASE SEX
    WHEN 'm' THEN 'f'
    ELSE 'm'
END;

-- fetching names of students if the id of the student is odd then don't swap with the previous name but swap when the previous id is even
/* Write your SQL query statement below */
SELECT 
    CASE
        WHEN id % 2 = 1 AND id + 1 <= (SELECT MAX(id) FROM Seat) THEN id + 1
        WHEN id % 2 = 0 THEN id - 1
        ELSE id
    END AS id,
    student
FROM Seat
ORDER BY id;

-- fetching the details of same hero , director who have directed for the same hero more than three time with same director also 
SELECT actor_id , director_id
FROM ActorDirector
GROUP BY actor_id , director_id
HAVING count(actor_id) >=3 
       AND count(director_id) >=3;

-- fetching same colums in the same table with different values in the two tables
SELECT a2.product_name AS product_name , 
       a1.year AS year ,
       a1.price AS price
FROM Sales  a1
LEFT JOIN Product  a2
ON a1.product_id = a2.product_id;

-- fetching details when the author viewed his own article at the same viewer_id and same author_id
SELECT author_id AS id 
FROM Views 
GROUP BY author_id , viewer_id
HAVING author_id = viewer_id
ORDER BY author_id ASC;

-- fetching the details with three tables who attempeted all the examinations which has a Students table , Subject table , Examination table 
SELECT
    S.student_id
    ,S.student_name
    ,SU.subject_name
    ,COUNT(E.student_id) attended_exams
FROM Students S
CROSS JOIN Subjects SU
LEFT JOIN Examinations E
    ON S.student_id = E.student_id
    AND SU.subject_name = E.subject_name

GROUP BY S.student_id, S.student_name, SU.subject_name
ORDER BY S.student_id, S.student_name, SU.subject_name
;

-- fetching the customers who bought all the products in the product table
SELECT customer_id
FROM Customer 
GROUP BY customer_id
HAVING COUNT(DISTINCT product_id) = (SELECT COUNT(*) FROM Products);

-- fetching the datils of students who have improved than previous exams results
WITH Ranked AS (
    SELECT
    student_id,
    subject,
    FIRST_VALUE(score) OVER(PARTITION BY student_id,subject ORDER BY exam_date) AS first_score,
    FIRST_VALUE(score) OVER(PARTITION BY student_id,subject ORDER BY exam_date DESC) AS latest_score
    FROM Scores
)
SELECT DISTINCT * FROM Ranked
WHERE first_score<latest_score
ORDER BY student_id,subject

-- fetching the highest number of friends does a user have. The table contains requester_id and the accepter_id we have to identify the pairs of friends and setch which id number has maximun number of friends
with cte as(
    select requester_id as friends
    from RequestAccepted
    union all
    select accepter_id as friends
    from RequestAccepted
)
select 
    friends as id,
    count(friends) as num
from cte
group by friends
order by num desc
limit 1;

-- checking the triangle is valid or not according to the values of x , y , x
SELECT * ,
IF (x+y>z and x+z>y and y+z>x , "Yes" , "No") AS triangle 
FROM Triangle;


-- fetching the experince of the employee of the particular project and finding the average experince of the employee who worked on the particular project 
SELECT project_id , ROUND(AVG(experience_years) , 2) AS average_years
FROM Project p1
JOIN Employee e1
ON p1.employee_id = e1.employee_id
GROUP BY project_id;

-- fetch the details of the node of tree according to the given algorithm of root , Inner , leaf. id 1 has two children but no parent so it is root , id 2 has one parent and two child so it is inner , id 3 has one parent but no children so it is leaf
SELECT 
    id , 
     CASE 
        WHEN p_id IS NULL THEN 'Root'
        WHEN id IN (SELECT distinct p_id FROM Tree WHERE p_id IS NOT NULL ) THEN 'Inner'
        ELSE 'Leaf'
END AS type 
FROM Tree;

-- fetching the details of the product which us launched in the first year and quantity 
SELECT product_id , year AS first_year , quantity , price 
FROM Sales
WHERE (product_id , year) IN (
    SELECT product_id , min(year)
    FROM Sales
    GROUP BY product_id
);


--fetching the details of the user with their join date , number of orders placed in 2019 and their id 
SELECT 
    u1.user_id AS buyer_id 
    ,u1.join_date
    ,IFNULL(COUNT(o1.order_id),0) AS orders_in_2019 
FROM users u1
LEFT JOIN orders o1
    ON u1.user_id=o1.buyer_id
    AND YEAR(order_date) = '2019'
GROUP BY u1.user_id, u1.join_date;

-- fetching the details of the product with chnaged prices in that particular dates and the maximum values of the product_id and if the price of the product_will should be change to one if that is changed in the particular date
SELECT product_id, new_price AS price 
FROM Products
WHERE(product_id,change_date) IN
(
    SELECT product_id, MAX(change_date)
    FROM Products
    WHERE change_date <= '2019-08-16'
    GROUP BY product_id
)
UNION
SELECT product_id, 10 AS price 
FROM Products
WHERE(product_id) NOT IN
(
    SELECT product_id
    FROM Products
    WHERE change_date <= '2019-08-16'
);


-- fetching the total returs loss/gain per one stock. In which we can buy and sell a single stock multiple times 
SELECT stock_name , 
SUM(CASE 
       WHEN operation = "Buy" THEN -price
       ELSE price
       END
) AS capital_gain_loss
FROM Stocks 
GROUP BY stock_name;


--fetching the details of the people with three or more conscutive id's and people in single id more than 100 or equal. Retrun in the asceding order of id
WITH filtered AS ( 
     SELECT id , id - ROW_NUMBER() OVER (ORDER BY id) AS grp
     FROM stadium 
     WHERE people >=100
);
valid_group AS (
    SELECT grp
    FROM filtered
    GROUP BY grp
    HAVING COUNT(*) >= 3
);
SELECT id , visit_date , people 
FROM filtered 
WHERE grp IN (SELECT grp FROM valid_group)
ORDER BY visit_date ASC;

--fetching the total amount of trasacations over the period of time and over a location 
SELECT 
    DATE_FORMAT(trans_date, '%Y-%m') AS month ,
    country ,
    count(id) AS trans_count ,
    SUM(CASE WHEN state = 'approved' THEN 1 ELSE 0 END) AS approved_count ,
    SUM(amount) AS trans_total_amount ,
    SUM(CASE WHEN state = 'approved' THEN amount ELSE 0 END) AS  approved_total_amount
FROM Transactions
GROUP BY month , country;


-- fetching the details of the final person who is going through a bus where the consition is maximum limit of the bus is 1000kgs 
SELECT person_name 
FROM 
   (
    SELECT person_name , 
    SUM(weight) OVER (ORDER BY Turn) AS Total_Weight
    FROM Queue
   ) t
WHERE Total_weight <=1000
ORDER BY total_weight DESC 
LIMIT 1;

-- fetching the details of number of follwes does a user have vice versa the follower follows the user 
SELECT user_id , count(follower_id) AS followers_count
FROM Followers
GROUP BY user_id 
ORDER BY user_id ASC;


-- fetching the salary details of the employee according to their salary 

SELECT 'Low Salary' AS category
    COUNT(IF(Salary < 20000 , 1 , NULL)) AS accounts_count
    FROM Accounts 
UNION
SELECT 'Average Salary' AS category
      COUNT(IF(salary >= 20000 AND salary <= 50000 ,1 , NULL)) AS accounts_count
      FROM Accounts
UNION
SELECT 'High Salary' AS category
      COUNT(IF(salary > 50000 ,1 , NULL)) AS accounts_count
      FROM Accounts


-- fetching the details of product which is ordered more than 100 units in he particular time period 

SELECT product_name , SUM(unit) AS unit 
FROM Products p1
LEFT JOIN Orders p2
ON p1.product_id = p2.product_id
WHERE order_date between "2020-02-01" and "2020-02-29"
GROUP BY p1.product_id
HAVING unit >= 100;


-- fetching the acceptnace rate in the request and accepting table 

SELECT s1.user_id , 
       ROUND(AVG(IF(c1.action = 'confirmed' , 1 , 0)) , 2) AS confirmation_rate
FROM Signups s1
LEFT JOIN Confirmations c1 
ON s1.user_id = c1.user_id 
GROUP BY s1.user_id;

-- fetching the teachers count with the number of unique subjects taught
SELECT teacher_id , count( distinct subject_id) AS cnt
FROM Teacher 
GROUP BY teacher_id;

-- fetching the product details which is sold in between 2019-01-01 and 2019-03-31

SELECT p1.product_id  AS product_id,p1.product_name AS product_name  
FROM Product p1
LEFT JOIN Sales s1
ON p1.product_id = s1.product_id
GROUP BY p1.product_id 
HAVING MIN(s1.sale_date) >= '2019-01-01' 
AND MAX(s1.sale_date) <= '2019-03-31';

--  fetching the total amount of bank balance which is trasferred greater than 10000 
    SELECT u1.name AS name , SUM(t1.amount) AS balance 
    FROM Users u1
    LEFT JOIN Transactions t1
    ON u1.account = t1.account 
    GROUP BY t1.account 
    HAVING balance > 10000;


-- fetching the employee_id with unique names by joining to tables
SELECT e2.unique_id  AS unique_id, e1.name AS name
FROM Employees AS e1
LEFT JOIN EmployeeUNI e2
ON e1.id = e2.id 
GROUP BY e1.id;

-- fetching the total distance a person with id travelled if two persons have same distance travelled then return 0 

SELECT u1.name AS name , IFNULL(SUM(distance) , 0) AS travelled_distance 
FROM Users u1
LEFT JOIN Rides r1
ON u1.id = r1.user_id
GROUP BY r1.user_id
ORDER BY travelled_distance DESC , name ASC;



-- fetching the number of products in same date and number of products 

select sell_date,
    count(distinct product) as num_sold,
    group_concat(distinct product order by product asc separator ",") as products
from activities
group by sell_date    

-- fetching the correct tweet which has the length of content greater than 15
SELECT tweet_id
FROM Tweets 
WHERE LENGTH(content) > 15;

-- fetching the product from three differnet store from a mixing table and reform the table 

SELECT product_id ,
'store1' AS store ,
store1 AS price 
FROM Products 
WHERE store1 IS NOT NULL
UNION 
SELECT product_id , 
'store2' AS store ,
store2 AS price 
FROM Products 
WHERE store2 IS NOT NULL
UNION
SELECT product_id ,
'store3' AS store ,
store3 AS price 
FROM Products
WHERE store3 IS NOT NULL;

-- return which product is both recyclable and low fat

SELECT product_id
FROM Products 
WHERE low_fats = "Y" AND recyclable = "Y";

-- finding the time stamp of the app user with the maximum time spent on the app in a day
SELECT event_day AS day , emp_id , sum(out_time - in_time) AS total_time 
FROM Employees 
GROUP BY day , emp_id;

