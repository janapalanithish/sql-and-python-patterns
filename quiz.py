
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
    ["A.structured quesy language" , "B.syntax query language" , "c.summary query lnaguage" , "D.same quesry language"],
    ["A.which consites rows and clom" , "B.collection of data in rows and colums" , "C.which consists rows" , "D.which has data "],
    ["A.which has data in specified object" , "B. which consists of data" , "C.which has data iin cloums" , "D.which has data packed"],
]

for i in range(len(question_list)):
    # 1. Print the question
    print(f"\nQuestion {i+1}: {question_list[i]["question"]}")