function touch(x,y)
    print(x)
    print(y)
end

function touch(table)
  print(table[1])
  print(table[2])
  touch(table[1], table[2])
  --touch(table[1], table[2])
end

print("HI")
touch({1,5})