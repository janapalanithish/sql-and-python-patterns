import time
class tup:
    def __init__(self):
        self.tuple = (1 , 2, 3 , 4 , 5)
        self.index = -1
    def __iter__(self):
        return self
    def __next__(self):
        if self.index < len(self.tuple) - 1 :
            self.index += 1
            return self.tuple[self.index]
        raise StopIteration
c1 = tup()
it = iter(c1)
for i in range(len(c1.tuple)):
    print(next(it))
    time.sleep(1)