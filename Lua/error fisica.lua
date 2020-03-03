io.stdout:setvbuf("no")

function tableprint(t,u)
  u = units[u] or ""
  for i,v in ipairs(t) do print(v..u) end
end
function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end
units = {"cm","s"}
g = 9.8
deltatrend = 0.40
checks = {5.74;10.95,6.50,4.95,6.90,6.63,6.55,9.50,9.05,9.68,3.52,6.00,5.53,7.91,5.05,7.99,8.09,10.11,13.53,7.42}
timechecks = {}
if not (#checks >= 20) then error("Pipi") end

table.sort(checks, function(a,b) return a>b end)
print("---medidas Originales","medidas: "..#checks)
tableprint(checks,1)

do
  local trendcheck = {checks[2],checks[#checks-1]}
  local loop = true
  while loop do
    for i,v in ipairs(checks) do
      if v > trendcheck[1]+deltatrend or v < trendcheck[2]-deltatrend then
        print(v,"Esta fuera de la moda")
        table.remove(checks,i)
        trendcheck = {checks[2],checks[#checks-1]}
        break
      else loop = false end
    end
  end
end
print("---medidas ordenados, y moda arreglada","medidas: "..#checks)
tableprint(checks,1)

for i,_ in ipairs(checks) do
  timechecks[i] = round(math.sqrt((checks[i]/100)/(0.5*g)),5)
end
print("---medidas transformados a tiempo","medidas: "..#timechecks)
tableprint(timechecks,2)

do 
  local x_,deltax,sumx = 0,0,{}
  for i,v in ipairs(timechecks) do
    x_ = x_ + v
  end
  x_ = round(x_,5)
  print("X_/n = "..x_,#timechecks)
  x_ = round(x_/#timechecks,5)
  print("X_ = "..x_)
  for i,v in ipairs(timechecks) do
    table.insert(sumx,(v-x_)^2)
  end
  for i,v in ipairs(sumx) do
    deltax = deltax+v
  end
  deltax = round(deltax,5)
  print("Delta X/(n*(n-1)) = "..deltax,#timechecks,(#timechecks*(#timechecks-1)))
  deltax = math.sqrt(deltax/(#timechecks*(#timechecks-1)))
  deltax = round(deltax,5)
  print("Delta X = "..deltax)
  print(("Medida Final: x = %s"):format(x_.."+-"..deltax))
  print(("Porcentaje de error: "..round((deltax/x_)*100,2)).."%")
end
