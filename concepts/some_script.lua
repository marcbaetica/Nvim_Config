-- basic.lua
print("Lua boilerplate starting")

-- variables
local x = 5
local y = 12

-- if / elseif / else
if x > y then
  print("x is greater than y")
elseif x == y then
  print("x equals y")
else
  print("x is less than y")
end

-- function
local function add(a, b)
  return a + b
end

print("add(3, 4) =", add(3, 4))

-- table (array + map)
local data = {
  10, 20, 30,
  name = "example",
  enabled = true
}

-- numeric for loop
print("Numeric for loop:")
for i = 1, 20 do
  print("  i =", i)
  os.execute('timeout /t 2 /nobreak > nul')
end

-- iterate array part
print("Array values:")
for i, v in ipairs(data) do
  print(i, v)
end

-- iterate key/value pairs
print("Key/value pairs:")
for k, v in pairs(data) do
  print(k, v)
end

-- while loop
local n = 3
print("While loop:")
while n > 0 do
  print("  n =", n)
  n = n - 1
end

-- string operations
local msg = "Lua is fun"
print(msg:upper())
print("Length:", #msg)

-- simple error handling
local ok, result = pcall(function()
  return 10 / 2
end)

if ok then
  print("Result:", result)
else
  print("Error:", result)
end

print("Lua boilerplate finished")

