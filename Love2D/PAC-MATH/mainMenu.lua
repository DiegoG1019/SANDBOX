mainMenu = {}
local flags
local loc_startingLevel = 1

function mainMenu.load()
  love.graphics.setDefaultFilter("nearest", "nearest", 1)
  
  --flags
    flags = {}
    flags.requestShutdown = false
    flags.gameLoad = false
    flags.showMenu = true
    flags.showOptions = false
    flags.showCredits = false
    flags.showScores = false
    flags.clearHighscores = false
    
    flags.showDebug = false
    
    if love.filesystem.exists("options.txt") then
  
      local table_options = {}
      file_options = love.filesystem.lines("options.txt")
      for line in file_options do
        table.insert(table_options, line)
      end
      
      if table_options[1] == "true" then
        main.flags.options.playMusic = true
      else
        main.flags.options.playMusic = false
      end
      
      if table_options[2] == "true" then
        main.flags.options.showBatt = true
      else
        main.flags.options.showBatt = false
      end
      
      if table_options[3] == "true" then
        main.flags.options.playSounds = true
      else
        main.flags.options.playSounds = false
      end
    
    else
      
      main.flags.options.playMusic = true
      main.flags.options.showBatt = true
      main.flags.options.playSounds = true
      
    end
    local flag_doScores = true
    local flag_saveFirstScore = false
    
    if flag_doScores then
      
      table_scores = {}
      local loc_tablescores = {}
      local index = 1
      local lines_count = 0
      
      if love.filesystem.exists("scores") then
        
        local file_scores = love.filesystem.lines("scores")
        
        for line in file_scores do
          table.insert(loc_tablescores, line)
          lines_count = lines_count + 1
        end
        
      else
        
        local loc_startingScores = {[1] = "DIEGOG", [2] = "169905006502000550100"}
        
        for k,v in ipairs(loc_startingScores) do
          table.insert(loc_tablescores, v)
          lines_count = 2
        end
        
        flag_saveFirstScore = true
        
      end
      
      while index <= lines_count do
        table_scores[loc_tablescores[index]] = loc_tablescores[(index+1)]
        index = index + 2
      end
      
    end
    
    file_scores = love.filesystem.newFile("scores")
    file_options = love.filesystem.newFile("options.txt")
    
    if flag_saveFirstScore then
      file_scores:open("a")
      file_scores:write(tostring("DIEGOG".."\n".."169905006502000550100".."\n"))
      file_scores:close()
    end
    
    loc_difficulty = main.difficulty
    
  --SUIT themeing
    graphics = {}
    graphics.buttons = {}
    graphics.themes = {}
    
    graphics.buttonLine = 70
    graphics.labelLine = 85
    
    graphics.themes.play = extensions.suit.new()
    graphics.themes.normal = extensions.suit.new()
    graphics.themes.exit = extensions.suit.new()
    graphics.themes.diff = extensions.suit.new()
    
    graphics.themes.play.theme = setmetatable({}, {__index = extensions.suit.theme})
    graphics.themes.normal.theme = setmetatable({}, {__index = extensions.suit.theme})
    graphics.themes.exit.theme = setmetatable({}, {__index = extensions.suit.theme})
    graphics.themes.diff.theme = setmetatable({}, {__index = extensions.suit.theme})
    
    graphics.themes.play.theme.color = {
        
        normal   = {bg = {255,0,0}, fg = {255,0,0}},
        hovered  = {bg = {0,255,0}, fg = {0,255,0}},
        active   = {bg = {0,255,0}, fg = {0,255,0}}
        
      }
      
    graphics.themes.diff.theme.color = {
        
        normal   = {bg = {255,0,0}, fg = {255,0,0}},
        hovered  = {bg = {0,255,0}, fg = {0,255,0}},
        active   = {bg = {0,255,0}, fg = {0,255,0}}
        
      }
      
    graphics.themes.normal.theme.color = {
        
        normal   = {bg = {0,148,255}, fg = {0,148,255}},
        hovered  = {bg = {0,255,216}, fg = {0,255,216}},
        active   = {bg = {0,255,216}, fg = {0,255,216}}
        
      }
      
    graphics.themes.exit.theme.color = {
        
        normal   = {bg = {255,148,0}, fg = {255,148,0}},
        hovered  = {bg = {142,11,0}, fg = {142,11,0}},
        active   = {bg = {142,11,0}, fg = {142,11,0}}
        
      }
      
    --Assets
    sounds = {}
      --Sounds
        sounds.menuMusic = love.audio.newSource("assets/sounds/menu.wav")
        sounds.menuMusic_count = 0
        
        sounds.buttonSound = love.audio.newSource("assets/sounds/button.mp3")
        
      --Images
        
        graphics.pacGhosts = love.graphics.newImage("assets/graphics/pacghost.png")
        local sprite_sheet = extensions.anim8.newGrid(22, 22, 154, 115)
    
        graphics.pacman_anim = extensions.anim8.newAnimation(sprite_sheet("1-2", 1), 0.009)
        graphics.blinky = extensions.anim8.newAnimation(sprite_sheet(1, 3), 1)
        graphics.addition = extensions.anim8.newAnimation(sprite_sheet(3, 3), 1)
        graphics.substraction = extensions.anim8.newAnimation(sprite_sheet(4, 3), 1)
        graphics.division = extensions.anim8.newAnimation(sprite_sheet(5, 3), 1)
        graphics.multiplication = extensions.anim8.newAnimation(sprite_sheet(6, 3), 1)
        
        pacPos = love.graphics.getWidth() + 60
        pacY = math.random(love.graphics.getHeight() - 50, love.graphics.getHeight() + 50)
        signRot = 0
        
        exitCount = 0.5

end

function mainMenu.update(dt)
  
  graphics.pacman_anim:update(dt)
  
  if main.flags.options.playMusic then
    sounds.menuMusic:play()
    
    sounds.menuMusic_count = sounds.menuMusic_count + dt
    if sounds.menuMusic_count >= 30.5 then
      sounds.menuMusic_count = 0
      sounds.menuMusic:rewind()
    end
  else
    sounds.menuMusic:stop()
    sounds.menuMusic_count = 0
  end
  
  if flags.clearHighscores then
    flags.requestShutdown = false
    flags.gameStart = false
    flags.showMenu = false
    flags.showOptions = false
    flags.showCredits = false
    flags.showScores = true
    flags.showControls = false
    
    flags.clearHighscores = false
  end
  
  if flags.showMenu then
  
  --Define the buttons and behaviours
    if graphics.themes.play:Button("PLAY", main.window_middleX-(250/2),(graphics.buttonLine * 2), 250,50).hit then
      flags.requestShutdown = false
      flags.gameLoad = true
      flags.showMenu = false
      flags.showOptions = false
      flags.showCredits = false
      flags.showScores = false
      flags.showControls = false
      
      flags.playButtonSound = true
    end
    
    if graphics.themes.diff:Button("up", main.window_middleX-(250/2) + 255+55, ((graphics.buttonLine * 2)-30), 75,30).hit then
      if loc_startingLevel then
        loc_startingLevel = loc_startingLevel + 1
      end
      flags.playButtonSound = true
    end
    
    graphics.themes.diff:Label("Starting level: "..tostring(loc_startingLevel), main.window_middleX-(250/2) + 230, (graphics.buttonLine * 2), 300,30)
    
    if graphics.themes.diff:Button("down", main.window_middleX-(250/2) + 255+55, ((graphics.buttonLine * 2)+30), 75,30).hit then
      if loc_startingLevel > 1 then
        loc_startingLevel = loc_startingLevel - 1
      end
      flags.playButtonSound = true
    end
    
    if graphics.themes.normal:Button("HIGH SCORE", main.window_middleX-(250/2),(graphics.buttonLine * 3), 250,50).hit then
      flags.requestShutdown = false
      flags.gameStart = false
      flags.showMenu = false
      flags.showOptions = false
      flags.showCredits = false
      flags.showScores = true
      flags.showControls = false
      
      flags.playButtonSound = true
    end
    
    if graphics.themes.normal:Button("CREDITS", main.window_middleX-(250/2),(graphics.buttonLine * 4), 250,50).hit then
      flags.requestShutdown = false
      flags.gameStart = false
      flags.showMenu = false
      flags.showOptions = false
      flags.showCredits = true
      flags.showScores = false
      flags.showControls = false
      
      flags.playButtonSound = true
    end
    
    if graphics.themes.normal:Button("OPTIONS", main.window_middleX-(250/2),(graphics.buttonLine * 5), 250,50).hit then
      flags.requestShutdown = false
      flags.gameStart = false
      flags.showMenu = false
      flags.showOptions = true
      flags.showCredits = false
      flags.showScores = false
      flags.showControls = false
      
      flags.playButtonSound = true
    end
    
    if graphics.themes.normal:Button("HELP", main.window_middleX-(250/2),(graphics.buttonLine * 6), 250,50).hit then
      flags.requestShutdown = false
      flags.gameStart = false
      flags.showMenu = false
      flags.showOptions = false
      flags.showCredits = false
      flags.showScores = false
      flags.showControls = true
      
      flags.playButtonSound = true
    end
      
    if graphics.themes.exit:Button("EXIT", main.window_middleX-(250/2),(graphics.buttonLine * 7), 250,50).hit and exitCount == 0 then
      flags.requestShutdown = true
      flags.gameStart = false
      flags.showMenu = false
      flags.showOptions = false
      flags.showCredits = false
      flags.showScores = false
      flags.showControls = false
      
      flags.playButtonSound = true
    end
  
  end

  if flags.showScores then
    
    func_compareScores()
    
    if highscores.char[5] then
      graphics.themes.normal:Label(highscores.char[5].." | "..highscores.num[5], 0, (graphics.labelLine * 2), 800, 50)
    else
      graphics.themes.normal:Label("No scores available", 0, (graphics.labelLine * 2), 800, 50)
    end
    
    if highscores.char[4] then
      graphics.themes.normal:Label(highscores.char[4].." | "..highscores.num[4], 0, (graphics.labelLine * 2.5), 800, 50)
    end
    
    if highscores.char[3] then
      graphics.themes.normal:Label(highscores.char[3].." | "..highscores.num[3], 0, (graphics.labelLine * 3), 800, 50)
    end
    
    if highscores.char[2] then
      graphics.themes.normal:Label(highscores.char[2].." | "..highscores.num[2], 0, (graphics.labelLine * 3.5), 800, 50)
    end
    
    if highscores.char[1] then
      graphics.themes.normal:Label(highscores.char[1].." | "..highscores.num[1], 0, (graphics.labelLine * 4), 800, 50)
    end
    
    
    if main.mousePosX >= 275 and main.mousePosX <= 525 then
      if main.mousePosY >= 490 and main.mousePosY <= 540 then
        if love.mouse.isDown(1) then
          flags.requestShutdown = false
          flags.gameStart = false
          flags.showMenu = true
          flags.showOptions = false
          flags.showCredits = false
          flags.showScores = false
      
          flags.playButtonSound = true
          
          exitCount = 0.5
        end
      end
    end
    
    if graphics.themes.normal:Button("CLEAR", main.window_middleX-(250/2)+265,530, 100,50).hit then
      
        table_scores = nil
        table_scores = {["DIEGOG"] = "169905006502000550100"}
        
        flags.requestShutdown = false
        flags.gameStart = false
        flags.showMenu = false
        flags.showOptions = false
        flags.showCredits = false
        flags.showScores = false
        
        flags.playButtonSound = true
        
        flags.clearHighscores = true
        
        love.filesystem.remove("scores")
      
    end
  end

  if flags.showOptions then --In each toggle button, add a new "space" so SUIT can differentiate
    
    graphics.themes.normal:Label("TOGGLE MUSIC", (main.window_middleX-(250/2))+55, (graphics.buttonLine * 3), 250, 50)
    
    if graphics.themes.normal:Button("", main.window_middleX-(250/2), (graphics.buttonLine * 3), 50, 50).hit then
      
      if main.flags.options.playMusic then
        main.flags.options.playMusic = false
      else
        main.flags.options.playMusic = true
      end

  end
  
  graphics.themes.normal:Label("TOGGLE BATTERY", (main.window_middleX-(250/2))+55, (graphics.buttonLine * 4), 250, 50)
  if system.battery.state == "battery" or system.battery.state == "charging" or system.battery.state == "charged" then
    else
      extensions.suit.Label("Unsupported, no battery", {align = "left"}, (main.window_middleX-(250/2)+200),(graphics.buttonLine * 4+30), 300,50)
    end
  
  if graphics.themes.normal:Button(" ", main.window_middleX-(250/2), (graphics.buttonLine * 4), 50, 50).hit then
      
      if main.flags.options.showBatt then
        main.flags.options.showBatt = false
      else
        main.flags.options.showBatt = true
      end
      
      main.flags.playButtonSound = true

  end

  graphics.themes.normal:Label("TOGGLE SOUNDS", (main.window_middleX-(250/2))+55, (graphics.buttonLine * 5), 250, 50)
  
  if graphics.themes.normal:Button("  ", main.window_middleX-(250/2), (graphics.buttonLine * 5), 50, 50).hit then
      
      if main.flags.options.playSounds then
        main.flags.options.playSounds = false
      else
        main.flags.options.playSounds = true
      end
      
      flags.playButtonSound = true

  end
  
  end

  if flags.showControls then

    graphics.themes.normal:Label("Movement: Arrow Keys", 0, (graphics.labelLine * 1), 800, 50)
    graphics.themes.normal:Label("Claim Point: Space Bar", 0, (graphics.labelLine * 2), 800, 50)
    graphics.themes.normal:Label("Pause Game: Escape key", 0, (graphics.labelLine * 3), 800, 50)
    graphics.themes.normal:Label("IMPORTANT: Divisions are rounded down!", 0, (graphics.labelLine * 4), 800, 50)

  end

  if flags.showCredits then
    
    graphics.themes.normal:Label("DIEGO 'DIEGOG' GARCIA | PROGRAMMING AND DESIGN", 50, (graphics.labelLine * 2), 750,100)
    graphics.themes.normal:Label("FERNANDO 'ROKKERMOMO' PARRA | GRAPHIC ASSISTANT, AND PROGRAMMING ASSISTANT", 50, (graphics.labelLine * 3), 750,100)
    graphics.themes.normal:Label("NYANNOM1 | MUSIC CONTRIBUTIONS", 50, (graphics.labelLine * 4), 750,100)
    
  end
  
  if not flags.showMenu then
    
    if graphics.themes.normal:Button("RETURN", main.window_middleX-(250/2),(graphics.buttonLine * 7), 250,50).hit then
      flags.requestShutdown = false
      flags.gameStart = false
      flags.showMenu = true
      flags.showOptions = false
      flags.showCredits = false
      flags.showScores = false
      flags.showControls = false
      
      exitCount = 0.10
      
      flags.playButtonSound = true
    end
  
  end

    if flags.requestShutdown then
    
      flags.requestShutdown = false
      return "exit"
    
    end
    
    if flags.gameLoad then
      
      flags.gameLoad = false
      return "gameLoad", loc_startingLevel
  
    end
    
    if main.flags.playButtonSound and main.flags.options.playSounds then
      sounds.buttonSound:play()
      flags.playButtonSound = false
    end

    pacPos = pacPos - 5
    
    if pacPos <= -350 then
      pacPos = love.graphics.getWidth() + 60
      flags.pacYchange = true
    end
    
    if flags.pacYchange then
      flags.pacYchange = false
    math.randomseed(dt)
    pacY = math.random(200 - math.random(-20, 40), 600 + math.random(-20, 40))
    end
  
    signRot = signRot + 0.1
    
    if exitCount > 0 then
      exitCount = exitCount - dt
    else
      exitCount = 0
    end

end

function mainMenu.draw()
  
  love.graphics.setColor(255, 255, 255, 255)
  graphics.blinky:draw(graphics.pacGhosts, pacPos, pacY, 0, 3, 3)
  graphics.pacman_anim:draw(graphics.pacGhosts, pacPos - 80, pacY, 0, 3, 3)
  graphics.addition:draw(graphics.pacGhosts, pacY, pacPos, signRot, 3, 3)
  graphics.substraction:draw(graphics.pacGhosts, pacY-23, pacPos-(-43), signRot, 3, 3)
  graphics.division:draw(graphics.pacGhosts, pacY/2, pacPos/0.8, signRot, 3, 3)
  graphics.multiplication:draw(graphics.pacGhosts, pacY*1.2, pacPos*0.6, signRot, 3, 3)
  
  love.graphics.setFont(main.graphics.fonts.SGtitle)
  love.graphics.setColor(255, 216, 0, 255)
  love.graphics.print("PAC - MATH", main.window_middleX-(292/2), 40)
  
  love.graphics.setFont(main.graphics.fonts.REGnormal)

    love.graphics.setColor(255, 0, 0, 255)
    graphics.themes.play:draw()

    love.graphics.setColor(0, 148, 255, 255)
    graphics.themes.normal:draw()

    love.graphics.setColor(255, 148, 0, 255)
    graphics.themes.exit:draw()
  
    love.graphics.setFont(main.graphics.fonts.REGsmall)
    graphics.themes.diff:draw()

  if flags.showDebug then
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setFont(main.graphics.fonts.helveticaDebug)
    love.graphics.print("Main Menu data", 0, main.debugItem * 6)
    
    love.graphics.print("flags.requestShutdown = "..tostring(flags.requestShutdown), 0, main.debugItem * 8)
    love.graphics.print("flags.gameStart = "..tostring(flags.gameStart), 0, main.debugItem * 9)
    love.graphics.print("flags.showMenu = "..tostring(flags.showMenu), 0, main.debugItem * 10)
    love.graphics.print("flags.showOptions = "..tostring(flags.showOptions), 0, main.debugItem * 11)
    love.graphics.print("flags.showCredits = "..tostring(flags.showCredits), 0, main.debugItem * 12)
    love.graphics.print("flags.showScores = "..tostring(flags.showScores), 0, main.debugItem * 13)
    love.graphics.print("flags.showDebug = "..tostring(flags.showDebug), 0, main.debugItem * 14)
    love.graphics.print("flags.options.playMusic = "..tostring(flags.options.playMusic), 0, main.debugItem * 15)
    love.graphics.print("pacPos = "..pacPos, 0, main.debugItem * 16)
    love.graphics.print("pacY = "..pacY, 0, main.debugItem * 17)
    love.graphics.print("mouseClick = "..tostring(love.mouse.isDown(1)), 0, main.debugItem * 18)
    love.graphics.print("mouseX = "..main.mousePosX, 0, main.debugItem * 19)
    love.graphics.print("mouseY = "..main.mousePosY, 0, main.debugItem * 20)
    love.graphics.print("exitCount = "..exitCount, 0, main.debugItem * 21)
  end
  
  if flags.showOptions then
    if main.flags.options.playMusic then
      main.graphics.checkMark:draw(main.graphics.miscSprites, (main.window_middleX-(250/2)+4), (graphics.buttonLine * 3))
    end
    if main.flags.options.showBatt then
      main.graphics.checkMark:draw(main.graphics.miscSprites, (main.window_middleX-(250/2)+4), (graphics.buttonLine * 4))
    end
    if main.flags.options.playSounds then
      main.graphics.checkMark:draw(main.graphics.miscSprites, (main.window_middleX-(250/2)+4), (graphics.buttonLine * 5))
    end
  end

end

function mainMenu.unload()
  
  sounds.menuMusic:stop()
  
  file_options:open("w")
  file_options:write(tostring(main.flags.options.playMusic).."\n"..tostring(main.flags.options.showBatt).."\n"..tostring(main.flags.options.playSounds))
  file_options:close()
  
end

function func_compareScores()
  
  local function sortScore(a, b)
    return a[1] < b[1]
  end
  
  highscores = nil
  collectgarbage()
  highscores = {}
  highscores.char = {}
  highscores.num = {}
  local index = 5
  
  table.sort(table_scores, sortScore)
  for key,value in pairs(table_scores) do 
    highscores.char[index] = key
    highscores.num[index] = value
    index = index - 1
  end
  
end

return mainMenu