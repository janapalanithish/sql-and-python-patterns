#sum of two indeces in the list by taking a target
x = [1 , 2 , 3 , 4]
target = 6
for i in range(len(x)):
    for j in range(i , len(x)):
        if(x[i] + x[j] == target):
            print([i , j])
            break

# even or odd comparision using bit manipulation
n1 = int(input("enter the number:"))
if(n1 & 1 == 0):
    print("even")
else:
    print("odd")