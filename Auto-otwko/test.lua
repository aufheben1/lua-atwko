
file = io.open("Tmp/test.tmp", "w")

file:write("1\n")
file:write("2")
file:close()

file = io.open("Tmp/test.tmp", "r")
print(file:read())
print(file:read())
print(file:read())