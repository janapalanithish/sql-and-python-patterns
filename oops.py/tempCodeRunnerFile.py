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