
# creating a class with a method details
class car:
    def __init__(self , brand , price):
        self.brand = brand
        self.price = price
        print(self.price , self.brand)
    def details(self):
        return self.brand , self.price
s1 = car("BMW M2" , "10000000")
print(s1.brand)
print(s1.details())


# creating a class employee with method with method incrementing salary 

class employee:
    def __init__(self , name , salary):
        self.name = name 
        self.salary = salary
    def increment_percentage(self , n):
        self.salary = self.salary + n/100
        return self.salary
s2 = employee("nithish" , 50000)
print(s2.increment_percentage(1000))

# calculating the area using one method
class area:
    def __init__(self , length , breath):
        self.length = length
        self.breath = breath
    def area_calc(self):
        return 3.14*self.length*self.breath
a1 = area(10 , 5)
print(a1.area_calc())

# taking a class atribute , school_name and printing the values by using one method 
class student:
    school_name = "sri chaitanya"
    def __init__(self , name , marks):
        self.name = name 
        self.marks = marks
    def grade(self):
        return self.name , self.marks , student.school_name
s0 = student("nithish" , 90)
print(s0.grade())

# creating 3 objects with three different school names
class student1:
    def __init__(self , school_name):
        self.school_name = school_name
        print(self.school_name)
    def details(self):
         return self.school_name
s3 = student1("sri chaitanya")
print(s3.details())
s4 = student1("narayana")
print(s4.details())
s5 = student1("vignan")
print(s5.details())

# creating a class with details brand , price , discountpercentage and creating another method for the calculation
class laptop:
    def __init__(self , brand , price , discountpercentage):
        self.brand = brand
        self.price = price
        self.discountpercentage = discountpercentage
    def calculation(self):
        self.price = self.price - (self.price * self.discountpercentage / 100)
        return self.price
lo = laptop("dell" , 10000 , 10)
print(lo.calculation())

# creating a class without __init__ method
class new:
    def thug(self , n1 , n2):
        self.n1 = n1
        self.n2 = n2
        return self.n1 + self.n2
n = new()
print(n.thug(10 , 11))

# creating the bank model with withdraw , deposit methods
class bankdetails:
    def __init__(self , balance):
        self.balance = balance
    def deposit(self, amount1):
        self.amount1 = amount1
        self.balance1 = self.balance + self.amount1
        return self.balance1
    def withdraw(self , amount2):
        self.amount2 = amount2
        self.balance2 = self.balance - self.amount2
        return self.balance2
    
b0 = bankdetails(10000)
print(b0.deposit(122))
print(b0.withdraw(100))
print(b0.balance1) # this will give an error
print(b0.balance2) # this will also gives an error
# both statements gives error because the attributes balance1 and balance2 are not defined in the class

class Mobile:
    def __init__(self, brand, price, imei):
        self.brand = brand
        self.price = price
        self.imei = imei   

    def final_imei(self):
        return "*" * 11 + self.imei[:4]

    def display_details(self):
        print("Brand:", self.brand)
        print("Price:", self.price)
        print("IMEI:", self.final_imei())
m0 = Mobile("Apple", 999, "9876543465432")
print(m0.final_imei())



# create a class with the payment method to buy a laptop in which methods for payment discounts like use credit card get 10% discount , for downpayments 15% discount , for business card 20% discount 

class payments:
    def __init__(self , finalcost):
        self.finalcost = finalcost
    def credit(self , n):
        self.n = n
        self.finalcost1 = self.finalcost - (self.finalcost * n/100)
        return self.finalcost1
    def downpayment(self , m):
        self.m = m
        self.finalcost2 = self.finalcost - (self.finalcost * m/100)
        return self.finalcost2
    def businesscar(self , y):
        self.y = y
        self.finalcost3 = self.finalcost - (self.finalcost * y/100)
        return self.finalcost3

pay0 = payments(20000)
print(pay0.credit(10))
print(pay0.downpayment(20))
print(pay0.businesscar(25))

#creating a situation when if we get an otp then at the bottom of the website it will show the otp is sent to number ******6847

class otp:
    def __init__(self , phonenumber):
        self.phonenumber = phonenumber

    def imp(self):
        return '*' * 6 + self.phonenumber[-4:]
o1 = otp("9866736847")
print(o1.imp())

class main:
    def __init__(self , name , discount1 , amount):
        self.name = name 
        self.discount1 = discount1
        self.amount = amount 
    def offer(self):
         self.amount = self.amount - (self.amount *self.discount1/100)
         return self.amount
a1 = main("nithish" , 10 , 1000)
print(a1.offer())

class product:
    def __init__(self , baseprice , finalprice , discount):
        self.baseprice = baseprice 
        self.finalprice = finalprice 
        self.discount = discount
    def get_offer(self):
        self.finalprice = self.baseprice - (self.baseprice * self.discount/100)
        return self.finalprice

p1 = product(1000 , 0 , 10)
print(p1.get_offer())

from abc import ABC , abstractmethod
class shape(ABC):
    @abstractmethod
    def area(self):
        pass
class circle(shape):
    def __init__(self , radius):
        self.radius = radius
    def area(self):
        return 3.14 * self.radius * self.radius
c1 = circle(5)
print(c1.area())

from abc import ABC ,abstractmethod
class amount(ABC):
    @abstractmethod
    def get(self):
        pass
class amount1(amount):
    def __init__(self , amount , discount):
        self.amount = amount
        self.discount = discount
    def get(self):
        return self.amount - (self.amount * self.discount/100)
a2 = amount1(1000 , 10  )
print(a2.get())


from abc import ABC , abstractmethod
class this(ABC):
    @abstractmethod
    def tv(self):
        pass
class this1(this):
    def __init__(self , channel):
        self.channel = channel
    def tv(self):
        return self.channel
v1 = this1("HBO")
print(v1.tv())




from abc import ABC , abstractmethod
class student1(ABC):
    @staticmethod
    def student(self , name):
        pass
    def id(self , student_id):
        pass
class s1(student1):
    def __init__(self , name , student_id):
        self.name = name 
        self.student_id = student_id
    @staticmethod
    def student(self , name):
        self.name = name
        return self.name
    def id(self , student_id):
        self.student_id = student_id
        return self.student_id

s2 = s1("nithish" , 12345)
print(s2.id())
print(s2.student())

from abc import ABC , abstractmethod
@staticmethod
class math(ABC):
    @staticmethod
    def add(self):
        pass 
class sum(math):
    def __init__(self , a , b):
        self.a = a 
        self.b = b
    def get_sum(self):
        return self.a + self.b
s0 = sum(5 , 10)
print(s0.get_sum())
