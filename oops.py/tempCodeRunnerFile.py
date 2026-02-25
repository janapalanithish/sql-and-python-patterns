class Mobile:
    def __init__(self, brand, price, imei):
        self.brand = brand
        self.price = price
        self.__imei = imei   # private variable

    def get_masked_imei(self):
        return "*" * 11 + self.__imei[-4:]

    def display_details(self):
        print("Brand:", self.brand)
        print("Price:", self.price)
        print("IMEI:", self.get_masked_imei())
m0 = Mobile("Apple", 999, "9876543465432")
print(m0.get_masked_imei())