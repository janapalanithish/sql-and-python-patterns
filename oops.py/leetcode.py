#sum of two indeces in the list by taking a target
x = [1 , 2 , 3 , 4]
target = 3
for i in range(len(x)):
    for j in range(i+1 , len(x)):
        if(x[i] + x[j] == target):
            print([i , j])
            break