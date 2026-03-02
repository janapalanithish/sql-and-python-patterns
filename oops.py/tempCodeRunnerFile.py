# even or odd comparision using bit manipulation
n1 = int(input("enter the number:"))
if(n1 & 1 == 0):
    print("even")
else:
    print("odd")