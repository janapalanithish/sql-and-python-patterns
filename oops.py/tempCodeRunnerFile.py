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