import math
n = [1 ,2 ,3 , 4, 5]
max_product = -math.inf
for i in range(len(n)):
    for j in range(i+1 , len(n)):
        print(n[i] , n[j])
        max_product = max(max_product , n[i]*n[j])
print(max_product)