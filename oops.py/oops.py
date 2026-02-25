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


