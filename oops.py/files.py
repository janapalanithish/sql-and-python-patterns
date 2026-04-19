f = open("new.txt" , "w+")
data = f.write("hi")
f.seek(0)
data1 = f.read()
f.close()


import re
text = "Python is powerful"
pattern = r"^Python"
if re.search(pattern, text):
    print("Pattern found")
else:
    print("Pattern not found")


import re
text = "Python123"
pattern = r"[A-Za-z]+"
m = re.match(pattern, text)
if m:
   print("Matched text:", m.group())
   print("Start index:", m.start())
   print("End index:", m.end())
   print("Span:", m.span())
else:
    print("No match found")


import datetime
now = datetime.date.today()
print("Current date:", now)