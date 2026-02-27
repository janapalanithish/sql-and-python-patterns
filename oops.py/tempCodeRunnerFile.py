class otp:
    def __init__(self , phonenumber):
        self.phonenumber = phonenumber

    def imp(self):
        return '*' * 6 + self.phonenumber[-4:]
o1 = otp("9866736847")
print(o1.imp())