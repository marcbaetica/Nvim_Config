

print('Test!')
print('Test2')

def funct_1(var1):
    '''Some defition.'''
    print(var1)

funct_1('Hello!')


if 'H' == 'H':              # Testing ligatures support.
    print('H exists!')

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

