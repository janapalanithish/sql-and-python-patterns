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

# printing the maximum product of two numbers in a list
import math
from operator import concat
n = [1 ,2 ,3 , 4, 5]
max_product = -math.inf
for i in range(len(n)):
    for j in range(i+1 , len(n)):
        print(n[i] , n[j])
        max_product = max(max_product , n[i]*n[j])
print(max_product)


# reversing of the array with O(1) space complexity
class Solution(object):
    def reverseString(self, s):
        """
        :type s: List[str]
        :rtype: None Do not return anything, modify s in-place instead.
        """
        for i in range(len(s)//2):   
           temp = s[i]
           s[i] = s[len(s)-1-i]        
           s[len(s)-1-i] = temp

               
