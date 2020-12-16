local loc_startingLevel

function love.load()
  
  love.graphics.setDefaultFilter("nearest", "nearest", 1)

  main = {}
  
  funcVar = {
    
    game = {
      
      gameRandom_calls = 0,
      newPoint_calls = 0,
      newGhostDest_calls = 0,
      mathMap_calls = 0,
      funcQuake_calls = 0
      
    },
    
    mainMenu = {
      
    checkButton_calls = 0
      
    }
    
  }
  
  -- Extensions
    extensions = {
      anim8 = require 'assets.scripts.extensions.anim8.anim8',
      suit = require 'assets.scripts.extensions.SUIT',
      scores = require 'assets.scripts.scores'
    }
    
    scripts = {
      options = require 'assets.scripts.options'
    }
    
  
  -- Flags
  main.flags = {
  
    gameStart = false,
    exit = false,
    gameLoad = false,
    unloadGame = false,
  
    inMenu = false,
    loadMenu = true,
    unloadMenu = false,
  
    showDebug = false,
    moreDebug = false,
    
    windowNormal = true,
    
    sysBatteryCharging = false,
    sysBatteryCharged = false,
    
    options = {},
    
    debug = {
     
      tools = false
     
    }
    
  }
  
  if main.flags.debug.tools then
    love.window.setMode(800,600)
  end

  -- Function Variables
      clock = {}
      
      clock.preseconds = 0
      clock.seconds = 0
      clock.minutes = 0
      clock.hours = 0
      --
      main.debugItem = 15
      --
      main.randomEnsurer = 0
      --
      main.window_width, main.window_height = love.graphics.getDimensions()
      main.window_middleX = main.window_width / 2
      main.window_middleY = main.window_height / 2
      main.difficulty = 1
      --
      main.UI_scaleX, main.UI_scaleY = 1, 1
      
      main.actor_scaleX, main.actor_scaleY = main.UI_scaleX * 1.3, main.UI_scaleY * 1.3
      
      main.gameOffsetX = 144 
      main.gameOffsetY = 34
      --
      main.randomValue = nil
      --
      system = {}
      system.battery = {}
      battX = 750
      system.cleanertime = 100
      battColors = {255, 255, 255}
      
  -- Assets
    main.graphics = {}
  
        main.graphics.miscSprites = love.graphics.newImage("assets/graphics/misc.png")
        local miscSprites = extensions.anim8.newGrid(44, 44, main.graphics.miscSprites:getWidth(), main.graphics.miscSprites:getHeight())
        
        main.graphics.checkMark = extensions.anim8.newAnimation(miscSprites(1, 1), 1)

        main.graphics.loadingAnim = extensions.anim8.newAnimation(miscSprites("2-4", 1), 0.09)
        
        main.graphics.chargeWire = extensions.anim8.newAnimation(miscSprites(1,2), 1)
        
        main.graphics.battOut1 = extensions.anim8.newAnimation(miscSprites(1,3), 1)
        main.graphics.battOut2 = extensions.anim8.newAnimation(miscSprites(2,3), 1)
        
        main.graphics.battChar1 = extensions.anim8.newAnimation(miscSprites(3,3), 1)
        main.graphics.battChar2 = extensions.anim8.newAnimation(miscSprites(4,3), 1)
        
        main.graphics.menuCursor = extensions.anim8.newAnimation(miscSprites(2,1), 1)
  
    
    main.graphics.fonts = {}
    
    main.graphics.fonts.SGtitle = love.graphics.newFont("assets/graphics/fonts/SG.ttf", 72)
    main.graphics.fonts.SGheader = love.graphics.newFont("assets/graphics/fonts/SG.ttf", 36)
    main.graphics.fonts.SGheader2 = love.graphics.newFont("assets/graphics/fonts/SG.ttf", 48)
    main.graphics.fonts.SGheader3 = love.graphics.newFont("assets/graphics/fonts/SG.ttf", 58)
    main.graphics.fonts.SGnormal = love.graphics.newFont("assets/graphics/fonts/SG.ttf", 16)
    main.graphics.fonts.SGsmall = love.graphics.newFont("assets/graphics/fonts/SG.ttf", 12)
    
    main.graphics.fonts.REGtitle = love.graphics.newFont("assets/graphics/fonts/FFFFORWA.ttf", 72)
    main.graphics.fonts.REGheader = love.graphics.newFont("assets/graphics/fonts/FFFFORWA.ttf", 24)
    main.graphics.fonts.REGheader2 = love.graphics.newFont("assets/graphics/fonts/FFFFORWA.ttf", 36)
    main.graphics.fonts.REGheader3 = love.graphics.newFont("assets/graphics/fonts/FFFFORWA.ttf", 48)
    main.graphics.fonts.REGnormal = love.graphics.newFont("assets/graphics/fonts/FFFFORWA.ttf", 16)
    main.graphics.fonts.REGsmall = love.graphics.newFont("assets/graphics/fonts/FFFFORWA.ttf", 4)
    main.graphics.fonts.REGheader4 = love.graphics.newFont("assets/graphics/fonts/FFFFORWA.ttf", 56)
    
    main.graphics.fonts.numberFont = love.graphics.newFont("assets/graphics/fonts/acknowtt.ttf", 24)
    
    main.graphics.buttonLine = 60
    
    main.colors = {
     
      cursor = {151, 27, 30}
      
    }

end

function love.update(dt)
  
  main.randomEnsurer = main.randomEnsurer + dt
  
  if main.flags.GlobalPause then
    extensions.suit.Label("GAME PAUSED. PLEASE FOCUS WINDOW.", 0,main.window_middleY, 800,50)
  else
  
  main.graphics.loadingAnim:update(dt)
  
  system.battery.state, system.battery.percent = love.system.getPowerInfo()
  
  main.mousePosX, main.mousePosY = love.mouse.getPosition()
  
  if system.battery.state == "battery" or system.battery.state == "charging" or system.battery.state == "charged" then
    main.flags.batteryPresent = true
  else
    main.flags.batteryPresent = false
  end
  
  if main.flags.batteryPresent then
    if system.battery.state == "charging" then
      main.flags.sysBatteryCharging = true
      main.flags.sysBatteryCharged = false
    elseif system.battery.state == "charged" then
      main.flags.sysBatteryCharging = false
      main.flags.sysBatteryCharged = true
    else
      main.flags.sysBatteryCharging = false
      main.flags.sysBatteryCharged = false
    end
  
      battY = (680 - system.battery.percent)-25
    
    if system.battery.percent > 50 then
  
      battPercentBlue = system.battery.percent * 1.2
      battPercentRed = system.battery.percent * 0.3
  
    elseif system.battery.percent < 50 then
  
      battPercentBlue = system.battery.percent * 0.3
      battPercentRed = system.battery.percent * 1.2
  
    end
  
    if main.flags.sysBatteryCharged then
  
      battColors = {115, 138, 197}
  
    else
  
      battColors = {battPercentRed, 0, battPercentBlue}
  
  end


  end
  
  if system.cleanertime <= 0 then
      collectgarbage()
    system.cleanertime = 100
  else
    system.cleanertime = system.cleanertime - dt
  end

  if main.flags.gameLoad then
    main.flags.unloadMenu = true
    game = require 'game'
    game.load(loc_startingLevel)
    main.flags.gameLoad = false
    main.flags.gameStart = true
  end
  
  if main.flags.gameStart then
    local game_action = game.update(dt)
    
    if game_action == "restart" then
      main.flags.gameStart = false
      main.flags.unloadGame = true
      main.flags.gameLoad = true
    end
    
    if game_action == "quit" then
      main.flags.gameStart = false
      main.flags.unloadGame = true
      main.flags.loadMenu = true
    end

  end
  
  if main.flags.unloadGame then
    main.flags.unloadGame = false
    main.flags.gameStart = false
    game.unload()
    package.loaded["game"] = nil
    collectgarbage()
  end
  
  if main.flags.loadMenu then
    mainMenu = require("mainMenu")
    mainMenu.load()
    main.flags.loadMenu = false
    main.flags.inMenu = true
  end
  
  if main.flags.inMenu then
    
    local mainMenu_Action, other = mainMenu.update(dt)
    
    if mainMenu_Action == "exit" then
      main.flags.unloadMenu = true
      main.flags.exit = true
    elseif mainMenu_Action == "gameLoad" then
      main.flags.gameLoad = true
      main.flags.unloadMenu = true
      loc_startingLevel = other
    end
    
  end
  
  if main.flags.unloadMenu then
    mainMenu.unload()
    package.loaded["assets.scripts.mainMenu"] = nil
    main.flags.inMenu = false
    main.flags.unloadMenu = false
  end
  
  if main.flags.exit then
    love.event.quit()
  elseif main.flags.restart then
    love.event.quit("restart")
  end
  
  --Version notice
  extensions.suit.Label("PAC-MATH BETA VERSION: 0.2.2", {align = "left"} , 0,main.window_height-40, 800,50)
  
  --Copyright notice
  if main.flags.inMenu then
    extensions.suit.Label("© 2017 Diego García. MIT License.", {align = "right"}, 0, main.window_height-40, 800,50)
  end

end

end


function love.draw()
  
  if main.flags.GlobalPause then
    extensions.suit.draw()
  else
  
  if main.flags.batteryPresent then
    if main.flags.options.showBatt then
      love.graphics.setColor(battColors, 255)
      
      main.graphics.battChar1:draw(main.graphics.miscSprites, 753, battY)
      main.graphics.battChar2:draw(main.graphics.miscSprites, 753, battY - 44)
      
      love.graphics.setColor(255, 255, 255, 255)
      main.graphics.battOut1:draw(main.graphics.miscSprites, 750, 556)
      main.graphics.battOut2:draw(main.graphics.miscSprites, 750, 556-44)
      
      
      if main.flags.sysBatteryCharging or main.flags.sysBatteryCharged then
        main.graphics.chargeWire:draw(main.graphics.miscSprites, 715, 520)
      end
      
    end
  end
  
  if main.flags.gameStart then
    game.draw()
  end
  
  if main.flags.inMenu then
    mainMenu.draw()
  end
  
  love.graphics.setFont(main.graphics.fonts.REGnormal)
  extensions.suit.draw()
  
  end
  
end

function love.keypressed(key, isrepeat)
  
  if main.flags.GlobalPause then
    
  else
    
    if love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl") then
      if love.keyboard.isDown("r") then
        main.flags.restart = true
      end
    end
    
    if main.flags.gameStart then
      game.keypressed(key, isrepeat)
    end
    
    lastKeyPress = key
    
  end

end

function love.focus(f)
  if f then
    main.flags.GlobalPause = false
  else
    main.flags.GlobalPause = true
  end
end
