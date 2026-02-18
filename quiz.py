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
    }
]

option_list = [
    ["A.structured query language" , "B.syntax query language" , "c.summary query lnaguage" , "D.same quesry language"],
    ["A.which consites rows and clom" , "B.collection of data in rows and colums" , "C.which consists rows" , "D.which has data "],
    ["A.which has data in specified object" , "B. which consists of data" , "C.which has data iin cloums" , "D.which has data packed"],
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


