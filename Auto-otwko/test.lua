
file = io.open("./Tmp/test.tmp", "r")

io.input(file)

a = io.read()
--print(io.read())

for i = 1, a do
  print("hello")
end

io.close()