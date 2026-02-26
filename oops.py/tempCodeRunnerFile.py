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