a = {5,7,9}
for i,v in ipairs(a) do
  if a[i+1] and v < a[i+1] then
    a[i],a[i+1] = a[i+1],a[i]
  end
end
for i,v in ipairs(a) do print(i,v) end