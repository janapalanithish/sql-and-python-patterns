import time
history = [ 
    {"key":"vallu iddaru lovers"} ,
    {"key":"vallu roju night vesukunrau"},
    {"key":"roju night yesukovadam valla {p2} detain ayyindi"},
    {"key":"kani {p2} agadu roju vestune undtadu"}
]
p1 = input("Enter the name of boy:")
p2 = input("enter the name of girl:")
p3 = input("do you want to calulate flames (yes/no):")

for i in range(len(history)):
    print(history[i]["key"].format(p1=p1 , p2=p2))
    time.sleep(2)