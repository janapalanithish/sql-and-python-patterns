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