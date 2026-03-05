
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

               
class Solution(object):
    def reverseVowels(self, s):
        """
        :type s: str
        :rtype: str
        """
        vowels = set('aeiouAEIOU')
        s = list(s)          # Convert to list (strings are immutable in Python)
        left, right = 0, len(s) - 1

        while left < right:
            # Move left pointer until it hits a vowel
            while left < right and s[left] not in vowels:
                left += 1
            # Move right pointer until it hits a vowel
            while left < right and s[right] not in vowels:
                right -= 1
            # Swap the two vowels
            s[left], s[right] = s[right], s[left]
            left += 1
            right -= 1

        return ''.join(s)