print('Test!')
print('Test2')

import sys
print(sys.version_info)
# print(sys.version)
print(sys.version)

def funct_1(var1):
    print(var1)

funct_1('Hello!')

print(sys.version)


from io import BytesIO

buffer = BytesIO()

buffer.write(b'Something')

print(buffer.getvalue(), buffer.getbuffer().nbytes)

buffer.seek(0)
buffer.truncate(0)

print(buffer.getvalue(), buffer.getbuffer().nbytes)


y = []

for x in range(10):
    y.append(x)

print(y)
print(type(y), type(y[0]))

