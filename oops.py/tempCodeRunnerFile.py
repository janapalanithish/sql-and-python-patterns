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