local flags, options
options = {}

function options.readOptions()
  
  flags.options = {}
  
  if love.filesystem.exists("options.txt") then
  
  local table_options = {}
  file_options = love.filesystem.lines("options.txt")
  for line in file_options do
    table.insert(table_options, line)
  end
  
  if table_options[1] == "true" then
    flags.options.playMusic = true
  else
    flags.options.playMusic = false
  end
  
  if table_options[2] == "true" then
    flags.options.showBatt = true
  else
    flags.options.showBatt = false
  end

  if table_options[3] == "true" then
    flags.options.playSounds = true
  else
    flags.options.playSounds = false
  end

  else
      
    flags.options.playMusic = true
    flags.options.showBatt = true
    flags.options.playSounds = true
  
  end

end

function options.clearOptions()

  if not love.filesystem.exists("options.txt") then
    return true
  else
    return assert(love.filesystem.remove("options.txt"), "Options not cleared")
  end
  
end

return options