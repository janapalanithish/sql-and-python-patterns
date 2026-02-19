user_info = [
    {
        "user_name":"nithish" ,
      "balance":10000
     },
    {
        "user_name":"karthik" ,
          "balance":10000 
     },
    {
        "user_name":"kumar",
      "balance":100009
      },
      {
          "user_name":"kantri",
          "balance":18443
      }
    
]

# Changed to a simple list of integers for easier comparison
pin_info = [
    53221,
    20333,
    82721,
    92465,
]

user_name1 = input("Enter you name:")
for i in range(len(user_info)):
    print()
print(f"hi {user_name1} enter your pin number")


# 1. Ask for the pin ONCE, outside the loop
pin = int(input("Enter the pin number: "))

# A flag variable to keep track of whether we found a match
is_verified = False

# 2. Loop through the pins to check for a match
for i in range(len(pin_info)):
    if pin == pin_info[i]:
        print("Your pin is verified! Your current balance is", user_info[i]["balance"])
        is_verified = True
        break  # Stop looping once we find a match

# 3. If the loop finishes and we didn't verify the pin, show an error
if not is_verified:
    print("Your pin is not verified.")