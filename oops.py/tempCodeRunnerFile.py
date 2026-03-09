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