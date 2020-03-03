actionval = 10

players = {
  {"_Turn",35,0,0},
  {"DiegoG",math.floor(20+20/1.5),0},
  {"Trasgo1",math.floor(14+16/1.5),0},
  {"Trasgo2",math.floor(13+12/1.5),0},
  {"Trasgo3",math.floor(13+11/1.5),0}
}

sort = function(a,b)
  if a[3] > b[3] then
    return true
  elseif a[3] < b[3] then
    return false
  elseif a[3] == b[3] then
    return false
  end
end

local startbattle = false

a = 0

while a<146 do
  for i,v in ipairs(players) do
    if not startbattle then
      i=i+1
    end
    players[i][3] = players[i][2]+players[i][3]
    startbattle = true
  end

  table.sort(players,sort)

  for i,v in ipairs(players) do
    if players[i][3] > 99 then
      players[i][3] = players[i][3]-100
      if players[i][1] == "_Turn" then
        players[i][4] = players[i][4]+6
        print("Turn number: ",players[i][4]/6,"Time passed: ",players[i][4])
      else
        local act = math.random(0,5)
        players[i][3] = players[i][2]+((actionval*5)-(act*actionval))
        print(v[1],"Speed: ",v[2]," CT: ",v[3]," Actions Taken: ",act)
      end
    end
  end
  
  a=a+1
end