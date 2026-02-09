CREATE TABLE info1(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    age INTEGER NOT NULL,
    email TEXT UNIQUE NOT NULL,
    rate_limits INTEGER NOT NULL,
    PLAN TEXT NOT NULL
    );
    INSERT INTO info1(id , name , age , email , rate_limits , PLAN)
    VALUES (?,?,?,?,?,?);
    SELECT name from info1;
    UPDATE info1
    SET rate_limits = 10
    WHERE id = 1;
    DELETE FROM info1
    WHERE rate_limits > 10;
    UPDATE info1
    SET PLAN = 'premium' , rate_limits = 1000
    WHERE id = 1;
    CREATE TABLE info3(
    name INTEGER NOT NULL,
    age INTEGER NOT NULL,
    email UNIQUE NOT NULL,
    id INTEGER AUTOINCREMENT PRIMARY KEY,
    rate_limits INTEGER ,
    PLAN TEXT NOT NULL
    );
    INSERT INTO info3(name , age , email , rate_limits , PLAN)
    VALUES(?,?,?,?,?);
    SELECT PLAN FROM info3;
    UPDATE info3
    SET rate_limits = 100
    SET PLAN = 'premium'
    WHERE id = 1;
    DATABASE school;
    CREATE TABLE course (
    rollnumber INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    class INTEGER NOT NULL,
    );
    CREATE TABLE fees(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    fees_left INTEGER NOT NULL,
    );
    VALUES course (?,?,?,?);
    VALUES fees (?,?,?);
    UPDATE fees 
    SET fees_left = 0
    WHERE id = 1;
    CREATE TABLE hosptal (
    patient_name TEXT NOT NULL,
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    age INTEGER NOT NULL,
    );
    VALUES hospital (?,?,?,?);
    USE school;
    CREATE DATABASE salary;
    USE salary;
    CREATE TABLE employinfo(
    emplid INTEGER AUTOINCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    salary INTEGER NOT NULL,
    );
    INSERT INTO employinfo(name ,salary)
    VALUES ("raj" , 1200),
    ("nithish" , 1000),
    ("riti" , 1300);
    CREATE DATABASE class;
    USE class;
    CREATE TABLE student (
    roll_no INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(50) NOT NULL,
    age INTEGER NOT NULL,
    class INTEGER NOT NULL
    );
    INSERT INTO student (name, age, class)
    VALUES ("nithish" , 15 , 10);
           ("mike" , 23 , 24);
           ("riki" ,21, 12);
        CREATE DATABASE IF NOT EXISTS instagramdb;
USE instagramdb;
CREATE TABLE instagramdb(
    id INTEGER PRIMARY AUTOINCREMENT;
    user_name TEXT NOT NULL;
    posts_created INTEGER PRIMARY KEY;
    no_views INTEGER PRIMARY KEY;
    email TEXT NOT NULL
);
INSERT INTO instagramdb(id , user_name , postes_c eated , no_views , email);
VALUES(?,?,?,?,?);
UPDATE instagramdb 
SET no_views = no_views + 1;
WHERE id = 1;
