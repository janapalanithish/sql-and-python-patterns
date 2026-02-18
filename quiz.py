import time 
score = 0
question_list = [
    {
        "question": "What is sql full form",
        "answer": "A"
    },
    {
        "question": "Define tables in sql",
        "answer": "B"
    },
    {
        "question": "Define the columns in sql",
        "answer": "A"
    },
    {
        "question":"can we cange the database or tablename or columnname" ,
        "answer":"B"
    },
    {
        "question":"how we can change the data in the column in sql",
        "answer":"D"
    },
    {
        "question":"how we can connect a not null and unique column from one table to another table",
        "answer":"C"
    },
    {
        "question":"what does a truncate command does",
        "answer":"C"
    }
    
]

option_list = [
    ["A.structured query language" , "B.syntax query language" , "c.summary query lnaguage" , "D.same quesry language"],
    ["A.which consites rows and clom" , "B.collection of data in rows and colums" , "C.which consists rows" , "D.which has data "],
    ["A.which has data in specified object" , "B. which consists of data" , "C.which has data iin cloums" , "D.which has data packed"],
    ["A.maybe" , "B.YES" , "C.No" , "D.we can but with condition"],
    ["A.by using delete command" , "B. by using group by command" , "C. by using distinct command" , "D.by using update command"],
    ["A.Using update command" , "B.By using onlt primary key" , "C. By using primary key and forign key" , "D.we cannot do"],
    ["A.deletes the complete table" , "B.removes the table from the database" , "C.deletes all the rowns and columns in the table and returns empty table" , "D.deletes the entire database"],

]
score = 0

for index in range(len(question_list)):

    print(question_list[index]["question"])
    
    for option in option_list[index]:
        print(option)
    
    guess = input("ENTER YOUR ANSWER (A/B/C/D): ").upper()

    correct_answer = question_list[index]["answer"]

    if guess == correct_answer:
        print("Correct answer\n")
        score += 1
    else:
        print("Incorrect answer\n")

print("Final Score:", score)


