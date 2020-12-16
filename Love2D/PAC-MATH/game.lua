local player, red, blue, orange, green, map, colors, GNL, positions, graphics, sounds, points, rollControl, options, _loc, flags, randomValue, menu, game, gameFunc
game = {}
gameFunc = {}
local loc_startingLevel

function game.load(loc_startingLevelw)
  
  main.difficulty = 1
  
  loc_startingLevel = loc_startingLevelw
  
  options = {
    gridMode = "fill"
  }
  
  randomValue = {}
  
  _loc = {
    
    levelCheck = {
      claimed = 0
    },
    
    quake = 0,
    quakeTime = 0.5,
    cellSize = 32,
    scoreAcc = 10,
    labelLine = 30,
    scoreTileIndex = 1,
    point_rot = 0,
    colorChange = 10,
    newMapCheck = 0,
    levelColorCheck = 0,
    levelColorCheckMult = 15,
    levelTransition_count = 3,
    randomCounter = 0,
    
    moveCounter = 0,
    deathAnim = 0,
    
    usernameIndex = 1,
    username = {"","","","","",""}
  }
  
  if main.difficulty >= 1 then
    _loc.scoreAcc = 50
  elseif main.difficulty >= 2 then
    _loc.scoreAcc = 80
  elseif main.difficulty >= 3 then
    _loc.scoreAcc = 120
  end

  flags = {
    
    debug = {
      
      doAutoMove = true,
      canDie = true
      
    },
    
    sound = {
      upScore = false,
      downScore = false,
      normal = true,
      song = true,
      death = false
    },
    
    playerAct = false,
    paused = false,
    reload = true,
    rollPoints = true,
    restartRollControl = true,
    newPoint = true,
    newDest = false,
    scoreTileUp = true,
    changeStageColor = true,
    renewTime = false,
    quake = false,
    ghostOut = false,
    levelTransition = false,
    restart = false,
    quit = false,
    gameover = false,
    submit = false
  }
  
  local sprite_sheet = extensions.anim8.newGrid(22, 22, 154, 115)

  player = {
    grid_x = 160,
    grid_y = 288,
    act_x = 200,
    act_y = 200,
    speed = 10,
    
    orientation = "left",
    level = 1,
    score = 0,
    scorePrint = 0,
    time = 15,
    dead = false,
    lives = 3
  }
  
  red = {
    grid_x = 736,
    grid_y = 224,
    act_x = 200,
    act_y = 200,
    speed = 10,
    
    destPoint = 1
  }
    
  blue = {
    grid_x = 736,
    grid_y = 256,
    act_x = 200,
    act_y = 200,
    speed = 10,
    
    destPoint = 1
  }
  
  orange = {
    grid_x = 736,
    grid_y = 288,
    act_x = 200,
    act_y = 200,
    speed = 10,
    
    destPoint = 1
  }
  
  green = {
    grid_x = 736,
    grid_y = 320,
    act_x = 200,
    act_y = 200,
    speed = 10,
    
    destPoint = 1
  }
  
  map = {  
      {n,n,n,n,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
      {n,n,n,n,1,6,0,0,0,0,6,0,0,0,6,0,0,0,6,1},
      {n,n,n,n,1,0,1,1,1,1,0,1,1,1,0,1,1,1,0,1},
      {n,n,n,n,2.2,6,0,0,0,0,6,0,0,0,6,0,0,0,6,2.0},
      {n,n,n,n,1,0,1,1,0,1,0,1,1,1,0,1,1,1,0,1},
      {n,n,n,n,1,0,1,1,0,1,0,1,1,1,0,1,1,1,0,1,n,3,3,3},
      {n,n,n,n,1,6,0,0,6,0,6,0,0,0,6,0,6,1,0,1,n,3,4,3},
      {n,n,n,n,1,0,1,1,1,1,0,1,1,1,1,1,0,1,0,1,n,3,4,3},
      {n,n,n,n,1,0,1,0,0,1,0,1,0,0,0,1,0,1,0,1,n,3,4,3},
      {n,n,n,n,1,0,1,1,1,1,0,1,1,1,1,1,0,1,0,1,n,3,4,3},
      {n,n,n,n,1,0,1,1,6,0,6,0,0,0,0,0,6,1,0,1,n,3,3,3},
      {n,n,n,n,1,0,1,1,0,1,0,1,1,1,0,1,0,1,0,1},
      {n,n,n,n,2.1,6,0,0,6,1,0,1,0,1,0,1,6,0,6,2.3},
      {n,n,n,n,1,0,1,1,1,1,0,1,1,1,0,1,1,1,0,1},
      {n,n,n,n,1,6,0,0,0,0,6,0,0,0,6,0,0,0,6,1},
      {n,n,n,n,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}
    }
  
  colors = {
    stage   = {0, 115, 239},
    
    ghostWall   = {255, 140, 16},
    ghostFloor  = {148, 84, 25},
    
    warpColor   = {18, 11, 55},
    warpColor2  = {81, 11, 55},
    
    default     = {225, 225, 225, 255},
    
    number      = {0, 115, 239},
    
    redGhost    = {204, 51, 51},
    blueGhost   = {51, 204, 204},
    orangeGhost = {204, 102, 102},
    greenGhost  = {204, 204, 51},
    
    scoreColor  = {200, 200, 200, 255},
    
    scoreTile   = {0, 0, 16},
    
    levelColor  = {255, 255, 255},
    
    menu = {
      
      normal = {15, 133, 220},
      selected = {243, 208, 42}
      
    }

  }
  _loc.actStageColor = colors.stage
  
  GNL = {
    problems = {},
    answers = {},
    color = {},
    current = 1
  }
  
  positions = {
    X = {
      [1]  = 192,
      [2]  = 352,
      [3]  = 480,
      [4]  = 608,
      
      [5]  = 192,
      [6]  = 352,
      [7]  = 480,
      [8]  = 608,
      
      [9]  = 192,
      [10] = 288,
      [11] = 352,
      [12] = 480,
      [13] = 544,
      
      [14] = 288,
      [15] = 352,
      [16] = 544,
      
      [17] = 192,
      [18] = 288,
      [19] = 544,
      [20] = 608,
      
      [21] = 192,
      [22] = 352,
      [23] = 480,
      [24] = 608
      
    },
    
    Y = {
      [1]  = 64,
      [2]  = 64,
      [3]  = 64,
      [4]  = 64,
      
      [5]  = 128,
      [6]  = 128,
      [7]  = 128,
      [8]  = 128,
      
      [9]  = 224,
      [10] = 224,
      [11] = 224,
      [12] = 224,
      [13] = 224,
      
      [14] = 352,
      [15] = 352,
      [16] = 352,
      
      [17] = 416,
      [18] = 416,
      [19] = 416,
      [20] = 416,
      
      [21] = 480,
      [22] = 480,
      [23] = 480,
      [24] = 480,
    }  
  }
  
  rollControl = {}
  
  graphics = {
   
    sprites = love.graphics.newImage("assets/graphics/pacghost.png"),
      
    pacman_anim = extensions.anim8.newAnimation(sprite_sheet("1-2", 1), 0.009),
    pacman_death1 = extensions.anim8.newAnimation(sprite_sheet("3-7", 1, "1-7", 2), 0.09),
      
    red_anim = extensions.anim8.newAnimation(sprite_sheet(1, 3), 1),
    blue_anim = extensions.anim8.newAnimation(sprite_sheet(1, 3), 1),
    orange_anim = extensions.anim8.newAnimation(sprite_sheet(1, 3), 1),
    green_anim = extensions.anim8.newAnimation(sprite_sheet(1, 3), 1),
    
    pac_point = extensions.anim8.newAnimation(sprite_sheet(2, 3), 1),
    
    levelTransition_image = love.graphics.newImage("assets/graphics/levelTransition.png")
    
  }
  
  graphics.levelTransition = love.graphics.newParticleSystem(graphics.levelTransition_image, 1000)
  graphics.levelTransition:setParticleLifetime(1,10)
  graphics.levelTransition:setEmissionRate(500)
  graphics.levelTransition:setSizeVariation(1)
  graphics.levelTransition:setLinearAcceleration(-250, -250, 250, 250)
    
    sounds = {
        
      chomp = love.audio.newSource("assets/sounds/pacman_chomp.wav"),
      chomp_count = 0.3,
        
      loading = love.audio.newSource("assets/sounds/pacman_loading.wav"),
      loaded = love.audio.newSource("assets/sounds/pacman_loaded.wav"),
        
      death = love.audio.newSource("assets/sounds/pacman_death.wav"),
      death_count = 1.3,
        
      scoreIncrease = love.audio.newSource("assets/sounds/scoreUp.mp3"),
      scoreDecrease = love.audio.newSource("assets/sounds/scoreDown.mp3")
      
    }
  
  points = {
    
    true, true, true, true, true, true, true, true, true,
    true, true, true, true, true, true, true, true, true,
    true, true, true, true, true, true, true, true
    
  }
  
  menu = {
    
    pause = {
      
      index = 1,
      
      cursorPos = {
       
        ((main.graphics.buttonLine * 2) - 48/2),
        ((main.graphics.buttonLine * 3) - 48/2),
        ((main.graphics.buttonLine * 4) - 48/2)
       
      }
    },
    
    gameover = {
      
      index = 1,
      
      cursorPos = {
        
        
        ((main.graphics.buttonLine * 2) - 48/2),
        ((main.graphics.buttonLine * 3) - 48/2),
        
      }
      
    }
    
  }
  
  if loc_startingLevel then
    gameFunc.newLevel(loc_startingLevel)
  end

end
 
function game.update(dt)
  
  if player.level > 7 then colors.stage = {0, 115, 239} end
  
  dt = dt * 1
  
  if flags.restart then return "restart" end
  if flags.quit then return "quit" end
  
  _loc.dt = dt
  
  randomValue[1] = map[(player.grid_y / _loc.cellSize)][(player.grid_x / _loc.cellSize)]
  randomValue[2] = player.grid_y.."|"..player.grid_x
  randomValue[3] = nil
  randomValue[4] = _loc.levelCheck.claimed
  randomValue[5] = nil
  
  if flags.paused then
    
    menu.pause.selected = menu.pause.index
    
  elseif flags.reload then

    local rollControl_index = 0
    local tempGNL = {}
    
    if main.difficulty <= 2 then
      GNL.color = {
        [1]  = {gameRandom(1, 255,  34), gameRandom(1, 255, 455), gameRandom(1, 255, 321)},
        [2]  = {gameRandom(1, 255,  45), gameRandom(1, 255,  54), gameRandom(1, 255, 564)},
        [3]  = {gameRandom(1, 255,  67), gameRandom(1, 255, 564), gameRandom(1, 255, 531)},
        [4]  = {gameRandom(1, 255,  85), gameRandom(1, 255, 665), gameRandom(1, 255, 564)},
        [5]  = {gameRandom(1, 255,  26), gameRandom(1, 255, 452), gameRandom(1, 255, 231)},
        [6]  = {gameRandom(1, 255,  78), gameRandom(1, 255, 564), gameRandom(1, 255,  22)},
        [7]  = {gameRandom(1, 255,  10), gameRandom(1, 255, 564), gameRandom(1, 255, 564)},
        [8]  = {gameRandom(1, 255,   5), gameRandom(1, 255, 564), gameRandom(1, 255,  85)},
        [9]  = {gameRandom(1, 255,  32), gameRandom(1, 255, 564), gameRandom(1, 255,  86)},
        [10] = {gameRandom(1, 255, 123), gameRandom(1, 255, 546), gameRandom(1, 255,  54)},
        [11] = {gameRandom(1, 255, 243), gameRandom(1, 255,  45), gameRandom(1, 255, 864)},
        [12] = {gameRandom(1, 255,  69), gameRandom(1, 255, 666), gameRandom(1, 255,  69)},
        [13] = {gameRandom(1, 255,  96), gameRandom(1, 255,  54), gameRandom(1, 255,  87)},
        [14] = {gameRandom(1, 255,  52), gameRandom(1, 255, 752), gameRandom(1, 255, 645)},
        [15] = {gameRandom(1, 255,  47), gameRandom(1, 255, 321), gameRandom(1, 255, 645)},
        [16] = {gameRandom(1, 255,  21), gameRandom(1, 255, 322), gameRandom(1, 255, 666)},
        [17] = {gameRandom(1, 255,   6), gameRandom(1, 255, 585), gameRandom(1, 255,  45)},
        [18] = {gameRandom(1, 255,   2), gameRandom(1, 255,  84), gameRandom(1, 255, 4568)},
        [19] = {gameRandom(1, 255,   4), gameRandom(1, 255, 645), gameRandom(1, 255, 545)},
        [20] = {gameRandom(1, 255, 122), gameRandom(1, 255,  64), gameRandom(1, 255, 546)},
        [21] = {gameRandom(1, 255,  91), gameRandom(1, 255, 684), gameRandom(1, 255, 458)},
        [22] = {gameRandom(1, 255, 111), gameRandom(1, 255, 514), gameRandom(1, 255, 125)},
        [23] = {gameRandom(1, 255, 223), gameRandom(1, 255, 864), gameRandom(1, 255, 333)},
        [24] = {gameRandom(1, 255,  36), gameRandom(1, 255, 352), gameRandom(1, 255, 254)}
      }
    else
      GNL.color = {}
      local index = 1
      
      while index <= 24 do
        GNL.color[index] = colors.number
        index = index + 1
      end
    end 

    if flags.restartRollControl then
      rollControl[1]  = true
      rollControl[2]  = true
      rollControl[3]  = true
      rollControl[4]  = true
      rollControl[5]  = true
      rollControl[6]  = true
      rollControl[7]  = true
      rollControl[8]  = true
      rollControl[9]  = true
      rollControl[10] = true
      rollControl[11] = true
      rollControl[12] = true
      rollControl[13] = true
      rollControl[14] = true
      rollControl[15] = true
      rollControl[16] = true
      rollControl[17] = true
      rollControl[18] = true
      rollControl[19] = true
      rollControl[20] = true
      rollControl[21] = true
      rollControl[22] = true
      rollControl[23] = true
      rollControl[24] = true
      
      flags.restartRollControl = false
    end
    
    if rollControl[1] then
      tempGNL.GNL1_A = gameRandom(-10, 10, 544, main.difficulty)
      tempGNL.GNL1_B = gameRandom(-5, 13, 197, main.difficulty)
      rollControl[1] = false
      
      GNL.problems[1] = tostring(tempGNL.GNL1_A.."+"..tempGNL.GNL1_B)
      GNL.answers[1] = tempGNL.GNL1_A + tempGNL.GNL1_B
    end
    
    if rollControl[2] then
      tempGNL.GNL2_A = gameRandom(-5, 5, 543, main.difficulty)
      tempGNL.GNL2_B = gameRandom(1, 16, 546, main.difficulty)
      rollControl[2] = false
      
      GNL.problems[2] = tostring(tempGNL.GNL2_A.."-"..tempGNL.GNL2_B)
      GNL.answers[2] = tempGNL.GNL2_A -tempGNL.GNL2_B
    end
    
    if rollControl[3] then
      tempGNL.GNL3_A = gameRandom(-7, 5, 5455, main.difficulty)
      tempGNL.GNL3_B = gameRandom(-64, 55, 53415, main.difficulty)
      rollControl[3] = false
      
      GNL.problems[3] = tostring(tempGNL.GNL3_A.."+"..tempGNL.GNL3_B)
      GNL.answers[3] = tempGNL.GNL3_A + tempGNL.GNL3_B
    end
    
    if rollControl[4] then
      tempGNL.GNL4_A = gameRandom(-14, 15, 654, main.difficulty)
      tempGNL.GNL4_B = gameRandom(3, 8, 64546, main.difficulty)
      rollControl[4] = false
      
      GNL.problems[4] = tostring(tempGNL.GNL4_A.."-"..tempGNL.GNL4_B)
      GNL.answers[4] = tempGNL.GNL4_A - tempGNL.GNL4_B
    end
    
    if rollControl[5] then
      tempGNL.GNL5_A = math.floor(main.difficulty * math.random(-9, 2))
      math.randomseed((os.clock() + main.randomEnsurer)*7)
      tempGNL.GNL5_B = math.floor(main.difficulty * math.random(-2, 16))
      math.randomseed((os.clock() + main.randomEnsurer)*8)
      rollControl[5] = false
      
      GNL.problems[5] = tostring(tempGNL.GNL5_A.."+"..tempGNL.GNL5_B)
      GNL.answers[5] = tempGNL.GNL5_A + tempGNL.GNL5_B
    end
    
    if rollControl[6] then
      tempGNL.GNL6_A = math.floor(main.difficulty * math.random(-5, 10))
      math.randomseed((os.clock() + main.randomEnsurer)*9)
      tempGNL.GNL6_B = math.floor(main.difficulty * math.random(1, 16))
      math.randomseed((os.clock() + main.randomEnsurer)/2)
      rollControl[6] = false
      
      GNL.problems[6] = tostring(tempGNL.GNL6_A.."x"..tempGNL.GNL6_B)
      GNL.answers[6] = tempGNL.GNL6_A * tempGNL.GNL6_B
    end
    
    if rollControl[7] then
      tempGNL.GNL7_A = math.floor(main.difficulty * math.random(-2, 21))
      math.randomseed((os.clock() + main.randomEnsurer)/3)
      tempGNL.GNL7_B = math.floor(main.difficulty * math.random(-2, 10))
      math.randomseed((os.clock() + main.randomEnsurer)/4)
      rollControl[7] = false
      
      GNL.problems[7] = tostring(tempGNL.GNL7_A.."x"..tempGNL.GNL7_B)
      GNL.answers[7] = tempGNL.GNL7_A * tempGNL.GNL7_B
    end
    
    if rollControl[8] then
      tempGNL.GNL8_A = math.floor(main.difficulty * math.random(-2, 15))
      math.randomseed((os.clock() + main.randomEnsurer)/5)
      tempGNL.GNL8_B = math.floor(main.difficulty * math.random(3, 8))
      math.randomseed((os.clock() + main.randomEnsurer)/6)
      rollControl[8] = false
      
      GNL.problems[8] = tostring(tempGNL.GNL8_A.."x"..tempGNL.GNL8_B)
      GNL.answers[8] = tempGNL.GNL8_A * tempGNL.GNL8_B
    end
    
    if rollControl[9] then
      tempGNL.GNL9_A = math.floor(main.difficulty * math.random(-5, 5))
      math.randomseed((os.clock() + main.randomEnsurer)/7)
      tempGNL.GNL9_B = math.floor(main.difficulty * math.random(0, 2))
      math.randomseed((os.clock() + main.randomEnsurer)/8)
      rollControl[9] = false
      
      GNL.problems[9] = tostring(tempGNL.GNL9_A.."x"..tempGNL.GNL9_B)
      GNL.answers[9] = tempGNL.GNL9_A * tempGNL.GNL9_B
    end
    
    if rollControl[10] then
      tempGNL.GNL10_A = math.floor(main.difficulty * math.random(-2, 3))
      math.randomseed((os.clock() + main.randomEnsurer)/9)
      tempGNL.GNL10_B = math.floor(main.difficulty * math.random(4, 5))
      math.randomseed((os.clock() + main.randomEnsurer)+12)
      rollControl[10] = false
     
      GNL.problems[10] = tostring(tempGNL.GNL10_A.."x"..tempGNL.GNL10_B)
      GNL.answers[10] = tempGNL.GNL10_A * tempGNL.GNL10_B
    end
    
    if rollControl[11] then
      tempGNL.GNL11_A = math.floor(main.difficulty * math.random(-1, 9))
      math.randomseed((os.clock() + main.randomEnsurer)+13)
      tempGNL.GNL11_B = math.floor(main.difficulty * math.random(1, 6))
      math.randomseed((os.clock() + main.randomEnsurer)+14)
      rollControl[11] = false
      
      GNL.problems[11] = tostring(tempGNL.GNL11_A.."x"..tempGNL.GNL11_B)
      GNL.answers[11] = tempGNL.GNL11_A * tempGNL.GNL11_B
    end
    
    if rollControl[12] then
      tempGNL.GNL12_A = math.floor(main.difficulty * math.random(1, 5))
      math.randomseed((os.clock() + main.randomEnsurer)+15)
      tempGNL.GNL12_B = math.floor(main.difficulty * math.random(0, 3))
      math.randomseed((os.clock() + main.randomEnsurer)+16)
      rollControl[12] = false
      
      GNL.problems[12] = tostring(tempGNL.GNL12_A.."x"..tempGNL.GNL12_B)
      GNL.answers[12] = tempGNL.GNL12_A * tempGNL.GNL12_B
    end
    
    if rollControl[13] then
      tempGNL.GNL13_A = math.floor(main.difficulty * math.random(1, 9))
      math.randomseed((os.clock() + main.randomEnsurer)+17)
      tempGNL.GNL13_B = math.floor(main.difficulty * math.random(1, 3))
      math.randomseed((os.clock() + main.randomEnsurer)+18)
      rollControl[13] = false
      
      GNL.problems[13] = tostring(tempGNL.GNL13_A.."x"..tempGNL.GNL13_B)
      GNL.answers[13] = tempGNL.GNL13_A * tempGNL.GNL13_B
    end
    
    if rollControl[14] then
      tempGNL.GNL14_A = math.floor(main.difficulty * math.random(-1, 10))
      math.randomseed((os.clock() + main.randomEnsurer)+19)
      tempGNL.GNL14_B = math.floor(main.difficulty * math.random(1, 10))
      math.randomseed((os.clock() + main.randomEnsurer)-10)
      rollControl[14] = false
      
      GNL.problems[14] = tostring(tempGNL.GNL14_A.."x"..tempGNL.GNL14_B)
      GNL.answers[14] = tempGNL.GNL14_A * tempGNL.GNL14_B
    end
    
    if rollControl[15] then
      tempGNL.GNL15_A = math.floor(main.difficulty * math.random(7, 10))
      math.randomseed((os.clock() + main.randomEnsurer)-20)
      tempGNL.GNL15_B = math.floor(main.difficulty * math.random(2, 8))
      math.randomseed((os.clock() + main.randomEnsurer)-30)
      rollControl[15] = false
      
      GNL.problems[15] = tostring(tempGNL.GNL15_A.."x"..tempGNL.GNL15_B)
      GNL.answers[15] = tempGNL.GNL15_A * tempGNL.GNL15_B
    end
    
    if rollControl[16] then
      tempGNL.GNL16_A = math.floor(main.difficulty * math.random(3, 6))
      math.randomseed((os.clock() + main.randomEnsurer)-40)
      tempGNL.GNL16_B = math.floor(main.difficulty * math.random(-6, 10))
      math.randomseed((os.clock() + main.randomEnsurer)-50)
      rollControl[16] = false
      
      GNL.problems[16] = tostring(tempGNL.GNL16_A.."/"..tempGNL.GNL16_B)
      GNL.answers[16] = math.floor(tempGNL.GNL16_A / tempGNL.GNL16_B)
    end
    
    if rollControl[17] then
      tempGNL.GNL17_A = math.floor(main.difficulty * math.random(-2, 9))
      math.randomseed((os.clock() + main.randomEnsurer)-60)
      tempGNL.GNL17_B = math.floor(main.difficulty * math.random(3, 56))
      math.randomseed((os.clock() + main.randomEnsurer)-70)
      rollControl[17] = false
      
      GNL.problems[17] = tostring(tempGNL.GNL17_A.."/"..tempGNL.GNL17_B)
      GNL.answers[17] = math.floor(tempGNL.GNL17_A / tempGNL.GNL17_B)
    end
    
    if rollControl[18] then
      tempGNL.GNL18_A = math.floor(main.difficulty * math.random(-5, 11))
      math.randomseed((os.clock() + main.randomEnsurer)-80)
      tempGNL.GNL18_B = math.floor(main.difficulty * math.random(10, 13))
      math.randomseed((os.clock() + main.randomEnsurer)-90)
      rollControl[18] = false
      
      GNL.problems[18] = tostring(tempGNL.GNL18_A.."/"..tempGNL.GNL18_B)
      GNL.answers[18] = math.floor(tempGNL.GNL18_A / tempGNL.GNL18_B)
    end
    
    if rollControl[19] then
      tempGNL.GNL19_A = math.floor(main.difficulty * math.random(4, 10))
      math.randomseed((os.clock() + main.randomEnsurer)+10)
      tempGNL.GNL19_B = math.floor(main.difficulty * math.random(1, 10))
      math.randomseed((os.clock() + main.randomEnsurer)+20)
      rollControl[19] = false
      
      GNL.problems[19] = tostring(tempGNL.GNL19_A.."/"..tempGNL.GNL19_B)
      GNL.answers[19] = math.floor(tempGNL.GNL19_A / tempGNL.GNL19_B)
    end
    
    if rollControl[20] then
      tempGNL.GNL20_A = math.floor(main.difficulty * math.random(1, 16))
      math.randomseed((os.clock() + main.randomEnsurer)+30)
      tempGNL.GNL20_B = math.floor(main.difficulty * math.random(0, 1))
      math.randomseed((os.clock() + main.randomEnsurer)+40)
      rollControl[20] = false
      
      GNL.problems[20] = tostring(tempGNL.GNL20_A.."/"..tempGNL.GNL20_B)
      GNL.answers[20] = math.floor(tempGNL.GNL20_A / tempGNL.GNL20_B)
    end
    
    if rollControl[21] then
      tempGNL.GNL21_A = math.floor(main.difficulty * math.random(-1, 13))
      math.randomseed((os.clock() + main.randomEnsurer)+50)
      tempGNL.GNL21_B = math.floor(main.difficulty * math.random(1, 4))
      math.randomseed((os.clock() + main.randomEnsurer)+560)
      rollControl[21] = false
      
      GNL.problems[21] = tostring(tempGNL.GNL21_A.."x"..tempGNL.GNL21_B)
      GNL.answers[21] = tempGNL.GNL21_A * tempGNL.GNL21_B
    end
    
    if rollControl[22] then
      tempGNL.GNL22_A = math.floor(main.difficulty * math.random(-7, 12))
      math.randomseed((os.clock() + main.randomEnsurer)+6)
      tempGNL.GNL22_B = math.floor(main.difficulty * math.random(1, 20))
      math.randomseed((os.clock() + main.randomEnsurer)+60)
      rollControl[22] = false
      
      GNL.problems[22] = tostring(tempGNL.GNL22_A.."-"..tempGNL.GNL22_B)
      GNL.answers[22] = tempGNL.GNL22_A - tempGNL.GNL22_B
    end
    
    if rollControl[23] then
      tempGNL.GNL23_A = math.floor(main.difficulty * math.random(30, 60))
      math.randomseed((os.clock() + main.randomEnsurer)+70)
      tempGNL.GNL23_B = math.floor(main.difficulty * math.random(-5, 30))
      math.randomseed((os.clock() + main.randomEnsurer)+80)
      rollControl[23] = false
      
      GNL.problems[23] = tostring(tempGNL.GNL23_A.."-"..tempGNL.GNL23_B)
      GNL.answers[23] = tempGNL.GNL23_A - tempGNL.GNL23_B
    end
    
    if rollControl[24] then
      tempGNL.GNL24_A = math.floor(main.difficulty * math.random(-1, 3))
      math.randomseed((os.clock() + main.randomEnsurer)+90)
      tempGNL.GNL24_B = math.floor(main.difficulty * math.random(1, 10))
      math.randomseed((os.clock() + main.randomEnsurer)*10)
      rollControl[24] = false
      
      GNL.problems[24] = tostring(tempGNL.GNL24_A.."x"..tempGNL.GNL24_B)
      GNL.answers[24] = tempGNL.GNL24_A * tempGNL.GNL24_B
    end
    
    flags.reload = false
    
  elseif player.dead then
    
    if _loc.deathAnim <= 1 then
      graphics.pacman_death1:update(dt)
      _loc.deathAnim = _loc.deathAnim + dt
    else
      flags.gameover = true
    end
    
    menu.gameover.selected = menu.gameover.index
    
    if main.flags.debug.tools then
      _loc.randomCounter = _loc.randomCounter + 1
    end
    
    if flags.confirmSubmit then
      local file_scores = love.filesystem.newFile("scores")
      file_scores:open("a")
      file_scores:write((_loc.username[1].._loc.username[2].._loc.username[3].._loc.username[4].._loc.username[5].._loc.username[6].."\n"..player.score))
      file_scores:close()
      return "quit"
    end
    
  else
    
    graphics.pacman_anim:update(dt)
    
    player.act_y = player.act_y - math.floor(((player.act_y - player.grid_y)) * player.speed * dt)
    player.act_x = player.act_x - math.floor(((player.act_x - player.grid_x)) * player.speed * dt)
    
    red.act_y = red.act_y - ((red.act_y - red.grid_y) * red.speed * dt)
    red.act_x = red.act_x - ((red.act_x - red.grid_x) * red.speed * dt)
    
    blue.act_y = blue.act_y - ((blue.act_y - blue.grid_y) * blue.speed * dt)
    blue.act_x = blue.act_x - ((blue.act_x - blue.grid_x) * blue.speed * dt)
    
    orange.act_y = orange.act_y - ((orange.act_y - orange.grid_y) * orange.speed * dt)
    orange.act_x = orange.act_x - ((orange.act_x - orange.grid_x) * orange.speed * dt)
    
    green.act_y = green.act_y - ((green.act_y - green.grid_y) * green.speed * dt)
    green.act_x = green.act_x - ((green.act_x - green.grid_x) * green.speed * dt)
    
    if player.scorePrint < player.score then
      player.scorePrint = player.scorePrint + _loc.scoreAcc
    elseif player.scorePrint > player.score then
      player.scorePrint = player.scorePrint - _loc.scoreAcc
    end
    
    if _loc.levelCheck.claimed >= 24 then
      _loc.levelCheck.claimed = 0
      gameFunc.newLevel()
    end
    
    if player.score == 0 then
      colors.scoreColor = {200, 200, 200, 255}
    elseif player.score < 0 then
      colors.scoreColor = {239, 64, 35, 255}
    elseif player.score > 0 then
      colors.scoreColor = {67, 120, 188, 255}
    end
    
    if flags.changeStageColor then
      
      if main.difficulty <= 3 then colors.stage = GNL.color[GNL.current] end
      
      if _loc.actStageColor[1] < colors.stage[1] then _loc.actStageColor[1] = _loc.actStageColor[1] + _loc.colorChange else _loc.actStageColor[1] = _loc.actStageColor[1] - _loc.colorChange end
      if _loc.actStageColor[2] < colors.stage[2] then _loc.actStageColor[2] = _loc.actStageColor[2] + _loc.colorChange else _loc.actStageColor[2] = _loc.actStageColor[2] - _loc.colorChange end
      if _loc.actStageColor[3] < colors.stage[3] then _loc.actStageColor[3] = _loc.actStageColor[3] + _loc.colorChange else _loc.actStageColor[3] = _loc.actStageColor[3] - _loc.colorChange end
      
    end
    
    if flags.newPoint then
      GNL.current = gameFunc.newPoint()
      
      local a = 1
      local isNumber = false
      if type(GNL.current) == type(a) then isNumber = true end
      assert(isNumber, "No new number issued.")
      
      flags.newPoint = false
      
    end
    
    if flags.newDest then
      
      red.grid_x = positions.X[red.destPoint]
      red.grid_y = positions.Y[red.destPoint]
      
      blue.grid_x = positions.X[blue.destPoint]
      blue.grid_y = positions.Y[blue.destPoint]
      
      orange.grid_x = positions.X[orange.destPoint]
      orange.grid_y = positions.Y[orange.destPoint]
      
      green.grid_x = positions.X[green.destPoint]
      green.grid_y = positions.Y[green.destPoint]
      
      red.destPoint, blue.destPoint, orange.destPoint, green.destPoint = gameFunc.newGhostDest()
      
      local a = 1
      local isNumber = false
      if type(red.destPoint) == type(a) then isNumber = true
        if type(blue.destPoint) == type(a) then isNumber = true
          if type(orange.destPoint) == type(a) then isNumber = true
            if type(green.destPoint) == type(a) then isNumber = true
              
            else isNumber = false end
          else isNumber = false end
        else isNumber = false end
      else isNumber = false end
      
      assert(isNumber, "No new number issued.")
      
      flags.newDest = false
    
    end
    
    if _loc.scoreTileIndex == 10 and flags.scoreTileUp then
      _loc.scoreTileIndex = 1
      flags.scoreTileUp = false
    elseif _loc.scoreTileIndex == 10 and not flags.scoreTileUp then
      _loc.scoreTileIndex = 1
      flags.scoreTileUp = true
    end
    
    if flags.scoreTileUp then
      _loc.scoreTileIndex = _loc.scoreTileIndex + 1
      colors.scoreTile[1] = colors.scoreTile[1] + 4
      colors.scoreTile[2] = colors.scoreTile[2] + 8
      colors.scoreTile[3] = colors.scoreTile[3] + 16
    else
      _loc.scoreTileIndex = _loc.scoreTileIndex + 1
      colors.scoreTile[1] = colors.scoreTile[1] - 4
      colors.scoreTile[2] = colors.scoreTile[2] - 8
      colors.scoreTile[3] = colors.scoreTile[3] - 16
    end
    
    if _loc.point_rot > 6 then _loc.point_rot = 0 end
    
    _loc.point_rot = _loc.point_rot + (6 * dt)
    
    if flags.renewTime then
      gameFunc.renewTime()
      flags.renewTime = false
    end
    
    player.time = player.time - dt
    
    if player.time <= 0 then flags.renewTime = true end
    
    if flags.quake then
      gameFunc.funcQuake()
      
      if _loc.quakeTime <= 0 then 
        flags.quake = false 
        _loc.quake = 0
      end
    end
    
    if flags.debug.canDie then
      if player.grid_y == red.grid_y then
        if player.grid_x == red.grid_x then
          player.dead = true
        end
      elseif player.grid_y == blue.grid_y then
        if player.grid_x == blue.grid_x then
          player.dead = true
        end
      elseif player.grid_y == orange.grid_y then
        if player.grid_x == orange.grid_x then
          player.dead = true
        end
      elseif player.grid_y == green.grid_y then
        if player.grid_x == green.grid_x then
          player.dead = true
        end
      end
    end
    
    if flags.ghostOut then
      if _loc.newMapCheck == 0 then
        map = {  
          {n,n,n,n,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
          {n,n,n,n,1,6,0,0,0,0,6,0,0,0,6,0,0,0,6,1},
          {n,n,n,n,1,0,1,1,1,1,0,1,1,1,0,1,1,1,0,1},
          {n,n,n,n,2.2,6,0,0,0,0,6,0,0,0,6,0,0,0,6,2.0},
          {n,n,n,n,1,0,1,1,0,1,0,1,1,1,0,1,1,1,0,1},
          {n,n,n,n,1,0,1,1,0,1,0,1,1,1,0,1,1,1,0,1},
          {n,n,n,n,1,6,0,0,6,0,6,0,0,0,6,0,6,1,0,1},
          {n,n,n,n,1,0,1,1,1,1,0,1,1,1,1,1,0,1,0,1},
          {n,n,n,n,1,0,1,0,0,1,0,1,0,0,0,1,0,1,0,1},
          {n,n,n,n,1,0,1,1,1,1,0,1,1,1,1,1,0,1,0,1},
          {n,n,n,n,1,0,1,1,6,0,6,0,0,0,0,0,6,1,0,1},
          {n,n,n,n,1,0,1,1,0,1,0,1,1,1,0,1,0,1,0,1},
          {n,n,n,n,2.1,6,0,0,6,1,0,1,0,1,0,1,6,0,6,2.3},
          {n,n,n,n,1,0,1,1,1,1,0,1,1,1,0,1,1,1,0,1},
          {n,n,n,n,1,6,0,0,0,0,6,0,0,0,6,0,0,0,6,1},
          {n,n,n,n,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}
        }
        _loc.newMapCheck = 1
      end
    end
    
    if _loc.levelColor == 1 then
      colors.levelColor = {gameRandom((127-(_loc.levelColorCheck*_loc.levelColorCheckMult)),(127+(_loc.levelColorCheck*_loc.levelColorCheckMult)), 54+funcVar.game.gameRandom_calls), gameRandom((127-(_loc.levelColorCheck*_loc.levelColorCheckMult)),(127+(_loc.levelColorCheck*_loc.levelColorCheckMult)), 697+funcVar.game.gameRandom_calls), gameRandom((127-(_loc.levelColorCheck*_loc.levelColorCheckMult)),(127+(_loc.levelColorCheck*_loc.levelColorCheckMult)), 6452+funcVar.game.gameRandom_calls)}
    end
    
    if flags.levelTransition then
      graphics.levelTransition:update(dt)
      graphics.levelTransition:setColors(255, 255, 255, 255, 255, 255, 255, 0)
    end
    
    if _loc.levelTransition_count > 0 then
      _loc.levelTransition_count = _loc.levelTransition_count -dt
    else
      _loc.levelTransition_count = 0
      flags.levelTransition = false
      graphics.levelTransition:reset()
    end
    
    if flags.debug.doAutoMove then
      if _loc.moveCounter >= 0.2 then
        player.act_y = player.grid_y
        player.act_x = player.grid_x
        _loc.moveCounter = 0
      end
      if flags.playerMoved then
        if player.grid_y == player.act_y then
          if player.grid_x == player.act_x then
            if player.orientation == "up" then
              if mathMap(0, -1) then
                player.grid_y = player.grid_y - _loc.cellSize
                flags.playerMoved = true
              end
            elseif player.orientation == "down" then
              if mathMap(0, 1) then
                player.grid_y = player.grid_y + _loc.cellSize
                flags.playerMoved = true
              end
            elseif player.orientation == "left" then
              if mathMap(-1, 0) then
                player.grid_x = player.grid_x - _loc.cellSize
                flags.playerMoved = true
              end
            elseif player.orientation == "right" then
              if mathMap(1, 0) then
                player.grid_x = player.grid_x + _loc.cellSize
                flags.playerMoved = true
              end
            end
          end
        end
      end
      _loc.moveCounter = _loc.moveCounter + dt
    end
    
  end
  
end
 
function game.draw()
  
  if flags.paused then
    
    love.graphics.setFont(main.graphics.fonts.SGtitle)
    love.graphics.setColor(255, 216, 0, 255)
    love.graphics.printf("PAUSED", 0, 40, 800, "center")
    
    love.graphics.setFont(main.graphics.fonts.SGheader2)
    if menu.pause.selected == 1 then love.graphics.setColor(colors.menu.selected) else love.graphics.setColor(colors.menu.normal) end
    love.graphics.printf("RESUME", 0, main.graphics.buttonLine * 2, 800, "center")
    if menu.pause.selected == 2 then love.graphics.setColor(colors.menu.selected) else love.graphics.setColor(colors.menu.normal) end
    love.graphics.printf("RESTART", 0, main.graphics.buttonLine * 3, 800, "center")
    if menu.pause.selected == 3 then love.graphics.setColor(colors.menu.selected) else love.graphics.setColor(colors.menu.normal) end
    love.graphics.printf("QUIT", 0, main.graphics.buttonLine * 4, 800, "center")
    
    love.graphics.setColor(main.colors.cursor)
    
    main.graphics.menuCursor:draw(main.graphics.miscSprites, 200, menu.pause.cursorPos[menu.pause.index], 0, 1.5, 1.5)
    
    
  elseif flags.reload then
    
  elseif player.dead and not flags.gameover then
    
    graphics.pacman_death1:draw(graphics.sprites, main.window_middleX, main.window_middleY, 0, 5,5, 22/2, 22/2)
    
  elseif flags.gameover then
    
    love.graphics.setFont(main.graphics.fonts.SGtitle)
    love.graphics.setColor(156, 54, 33)
    love.graphics.printf("GAME OVER", 0, 40, 800, "center")
    
    love.graphics.setFont(main.graphics.fonts.SGheader2)
    if menu.gameover.selected == 1 then love.graphics.setColor(colors.menu.selected) else love.graphics.setColor(colors.menu.normal) end
    love.graphics.printf("RESTART", 0, main.graphics.buttonLine * 2, 800, "center")
    if menu.gameover.selected == 2 then love.graphics.setColor(colors.menu.selected) else love.graphics.setColor(colors.menu.normal) end
    love.graphics.printf("SUBMIT", 0, main.graphics.buttonLine * 3, 800, "center")
    
    love.graphics.setColor(151, 27, 30)
    
    main.graphics.menuCursor:draw(main.graphics.miscSprites, 200, menu.gameover.cursorPos[menu.gameover.index], 0, 1.5, 1.5)
    
    if flags.submit then
      love.graphics.setColor(colors.default)
      love.graphics.setFont(main.graphics.fonts.SGheader)
      love.graphics.printf(_loc.username[1].._loc.username[2].._loc.username[3].._loc.username[4].._loc.username[5].._loc.username[6] or "", -30, main.graphics.buttonLine * 4, 800, "center")
      love.graphics.printf("PRESS ENTER TO SUBMIT!", 30, main.graphics.buttonLine * 5, 800, "center")
    end
    
  else
    
    love.graphics.setColor(_loc.actStageColor, 255)
    for y=1, #map do
      for x=1, #map[y] do
        if map[y][x] == 1 then
          love.graphics.rectangle(options.gridMode, (x * _loc.cellSize)+_loc.quake, (y * _loc.cellSize)-_loc.quake, _loc.cellSize, _loc.cellSize)
        end
      end
    end
    
    love.graphics.setColor(_loc.actStageColor[1], _loc.actStageColor[2], _loc.actStageColor[3], 4)
    for y=1, #map do
      for x=1, #map[y] do
        if map[y][x] == 0 or map[y][x] == 6 then
          love.graphics.rectangle(options.gridMode, (x * _loc.cellSize)-_loc.quake, (y * _loc.cellSize)+_loc.quake, _loc.cellSize, _loc.cellSize)
        end
      end
    end
    
    love.graphics.setColor(colors.ghostWall, 255)
     for y=1, #map do
      for x=1, #map[y] do
        if map[y][x] == 3 then
          love.graphics.rectangle("fill", (x * _loc.cellSize)-_loc.quake, (y * _loc.cellSize)-_loc.quake, _loc.cellSize, _loc.cellSize)
        end
      end
    end
    
    love.graphics.setColor(colors.ghostFloor, 255)
     for y=1, #map do
      for x=1, #map[y] do
        if map[y][x] == 4 then
          love.graphics.rectangle(options.gridMode, (x * _loc.cellSize)-_loc.quake, (y * _loc.cellSize)+_loc.quake, _loc.cellSize, _loc.cellSize)
        end
      end
    end
    
    love.graphics.setColor(colors.warpColor, 255)
     for y=1, #map do
      for x=1, #map[y] do
        if map[y][x] == 2.0 or map[y][x] == 2.1 then
          love.graphics.rectangle(options.gridMode, (x * _loc.cellSize)+(_loc.quake*-1), (y * _loc.cellSize)-_loc.quake, _loc.cellSize, _loc.cellSize)
        end
      end
    end
    
    love.graphics.setColor(colors.warpColor2, 255)
     for y=1, #map do
      for x=1, #map[y] do
        if map[y][x] == 2.2 or map[y][x] == 2.3 then
          love.graphics.rectangle(options.gridMode, (x * _loc.cellSize)+(_loc.quake*-1), (y * _loc.cellSize)-_loc.quake, _loc.cellSize, _loc.cellSize)
        end
      end
    end
    
    love.graphics.setColor(colors.scoreTile, 255)
     for y=1, #map do
      for x=1, #map[y] do
        if map[y][x] == 5 then
          love.graphics.rectangle(options.gridMode, (x * _loc.cellSize)+_loc.quake, (y * _loc.cellSize)-_loc.quake, _loc.cellSize, _loc.cellSize)
        end
      end
    end
    
    if true then
      local index = 1
      while index <= 24 do
        if points[index] then
          love.graphics.setColor(colors.scoreTile)
          graphics.pac_point:draw(graphics.sprites, positions.X[index]+16, positions.Y[index]+20, _loc.point_rot, 2,2, 22/2,22/2)
          love.graphics.setColor(GNL.color[index], 255)
          love.graphics.print(GNL.answers[index], positions.X[index], positions.Y[index], 0, 1, 1)
        else
          love.graphics.setColor(GNL.color[index][1], GNL.color[index][2],GNL.color[index][3], 10)
          love.graphics.print(GNL.answers[index], positions.X[index], positions.Y[index], 0, 1, 1)
        end
        index = index +1
      end
    end
    
    love.graphics.setColor(colors.default)
    
      love.graphics.setColor(colors.scoreColor)
      love.graphics.print("Score: "..math.floor(player.scorePrint), 5, (_loc.labelLine * 2))
      
      
      love.graphics.setColor(GNL.color[GNL.current][1]-80,GNL.color[GNL.current][2]+80,GNL.color[GNL.current][3]-20,255)
      love.graphics.rectangle("fill", main.window_middleX-240, -40, 16*32, 80)
      love.graphics.setColor(GNL.color[GNL.current],255)
      love.graphics.setFont(main.graphics.fonts.REGheader)
      love.graphics.printf("Answer = "..GNL.problems[GNL.current], 0, (_loc.labelLine * 0.3), 800, "center")
      love.graphics.setFont(main.graphics.fonts.REGnormal)
      
      love.graphics.setColor(colors.levelColor)
      love.graphics.print("Level: "..player.level, 5, (_loc.labelLine * 1))
      
      love.graphics.setColor(colors.default)
      love.graphics.print("Time left: "..math.ceil(player.time), 5, (_loc.labelLine * 3))
      
      if main.difficulty == 1 then
        
        love.graphics.setColor(colors.redGhost, 255)
        love.graphics.print("Watch for: ", 5, (_loc.labelLine * 4))
        love.graphics.setColor(GNL.color[red.destPoint], 255)
        love.graphics.print(GNL.answers[red.destPoint], 40, (_loc.labelLine * 5))
        
        love.graphics.setColor(colors.blueGhost, 255)
        love.graphics.print("Watch for: ", 5, (_loc.labelLine * 6))
        love.graphics.setColor(GNL.color[blue.destPoint], 255)
        love.graphics.print(GNL.answers[blue.destPoint], 40, (_loc.labelLine * 7))
        
        love.graphics.setColor(colors.orangeGhost, 255)
        love.graphics.print("Watch for: ", 5, (_loc.labelLine * 8))
        love.graphics.setColor(GNL.color[orange.destPoint], 255)
        love.graphics.print(GNL.answers[orange.destPoint], 40, (_loc.labelLine * 9))
        
        love.graphics.setColor(colors.greenGhost, 255)
        love.graphics.print("Watch for: ", 5, (_loc.labelLine * 10))
        love.graphics.setColor(GNL.color[green.destPoint], 255)
        love.graphics.print(GNL.answers[green.destPoint], 40, (_loc.labelLine * 11))
        
      else
        
        love.graphics.setColor(colors.redGhost, 255)
        love.graphics.print("Watch for: ", 5, (_loc.labelLine * 5))
        love.graphics.setColor(GNL.color[red.destPoint], 255)
        love.graphics.print(GNL.problems[red.destPoint], 40, (_loc.labelLine * 6))
        
        love.graphics.setColor(colors.blueGhost, 255)
        love.graphics.print("Watch for: ", 5, (_loc.labelLine * 7))
        love.graphics.setColor(GNL.color[blue.destPoint], 255)
        love.graphics.print(GNL.problems[blue.destPoint], 40, (_loc.labelLine * 8))
        
        love.graphics.setColor(colors.orangeGhost, 255)
        love.graphics.print("Watch for: ", 5, (_loc.labelLine * 9))
        love.graphics.setColor(GNL.color[orange.destPoint], 255)
        love.graphics.print(GNL.problems[orange.destPoint], 40, (_loc.labelLine * 10))
        
        love.graphics.setColor(colors.greenGhost, 255)
        love.graphics.print("Watch for: ", 5, (_loc.labelLine * 11))
        love.graphics.setColor(GNL.color[green.destPoint], 255)
        love.graphics.print(GNL.problems[green.destPoint], 40, (_loc.labelLine * 12))
        
      end
    --
    
    love.graphics.setColor(colors.default)
    
    if player.orientation == "up" then
      graphics.pacman_anim:draw(graphics.sprites, player.act_x-2, player.act_y-2, 1.58, main.actor_scaleX, main.actor_scaleY, 0, 22)
    elseif player.orientation == "down" then
      graphics.pacman_anim:draw(graphics.sprites, player.act_x-2, player.act_y-2, -1.58, main.actor_scaleX, main.actor_scaleY, 22, 0)
    elseif player.orientation == "left" then
      graphics.pacman_anim:draw(graphics.sprites, player.act_x-2, player.act_y-2, 0, main.actor_scaleX, main.actor_scaleY)
    elseif player.orientation == "right" then
      graphics.pacman_anim:draw(graphics.sprites, player.act_x-2, player.act_y-2, math.pi, main.actor_scaleX, main.actor_scaleY, 22, 22)
    end
    
    --
    love.graphics.setColor(colors.redGhost)
    graphics.red_anim:draw(graphics.sprites, red.act_x, red.act_y, 0, main.actor_scaleX, main.actor_scaleY)
    
    love.graphics.setColor(colors.blueGhost)
    graphics.blue_anim:draw(graphics.sprites, blue.act_x, blue.act_y, 0, main.actor_scaleX, main.actor_scaleY)
    
    love.graphics.setColor(colors.orangeGhost)
    graphics.orange_anim:draw(graphics.sprites, orange.act_x, orange.act_y, 0, main.actor_scaleX, main.actor_scaleY)
    
    love.graphics.setColor(colors.greenGhost)
    graphics.green_anim:draw(graphics.sprites, green.act_x, green.act_y, 0, main.actor_scaleX, main.actor_scaleY)
    --
    
    if flags.levelTransition then
      love.graphics.setColor(colors.levelColor)
      love.graphics.draw(graphics.levelTransition, love.graphics.getWidth() * 0.5, love.graphics.getHeight() * 0.5, _loc.point_rot)
    end
    
  end

  love.graphics.setColor(colors.default)
  love.graphics.setFont(main.graphics.fonts.REGnormal)
  
  if main.flags.debug.tools then love.graphics.print("Temp monitor: "..tostring(randomValue[1]).."|"..tostring(randomValue[2]).."|"..tostring(randomValue[3]).."|"..tostring(randomValue[4]).."|"..tostring(randomValue[5]), 0, 1) end

end
 
function game.keypressed(key)
  
  if not flags.submit then
    
    if flags.paused then
      
      if key == "down" then
        
        if menu.pause.index < 3 then
          menu.pause.index = menu.pause.index + 1
        end
        
      elseif key == "up" then
        
        if menu.pause.index > 1 then
          menu.pause.index = menu.pause.index - 1
        end
      
      end
      
      if key == "return" then
        if menu.pause.index == 1 then
          flags.paused = false
        elseif menu.pause.index == 2 then
          flags.restart = true
        elseif menu.pause.index == 3 then
          flags.quit = true
        end
      end
      
    elseif flags.reload then
      
    elseif flags.gameover then
      
      if key == "down" then
        
        if menu.gameover.index < 2 then
          menu.gameover.index = menu.gameover.index + 1
        end
        
      elseif key == "up" then
        
        if menu.gameover.index > 1 then
          menu.gameover.index = menu.gameover.index - 1
        end
      
      end
      
      if key == "return" then
        if menu.gameover.index == 1 then
          flags.restart = true
        elseif menu.gameover.index == 2 then
          flags.submit = true
        end
      end
      
    else
      
    if key == "up" then
      if mathMap(0, -1) then
        player.grid_y = player.grid_y - _loc.cellSize
        player.orientation = "up"
        flags.playerMoved = true
      end
    elseif key == "down" then
      if mathMap(0, 1) then
        player.grid_y = player.grid_y + _loc.cellSize
        player.orientation = "down"
        flags.playerMoved = true
      end
    elseif key == "left" then
      if mathMap(-1, 0) then
        player.grid_x = player.grid_x - _loc.cellSize
        player.orientation = "left"
        flags.playerMoved = true
      end
    elseif key == "right" then
      if mathMap(1, 0) then
        player.grid_x = player.grid_x + _loc.cellSize
        player.orientation = "right"
        flags.playerMoved = true
      end
    end
    
    if key == "space" then
      local act = playerAct()
      if main.flags.debug.tools then
        _loc.act = act
      end
      if act == "right" then
        
        flags.newPoint = true
        flags.sound.upScore = true
        gameFunc.playSound()
        
        if main.difficulty == 1 then
          player.score = player.score + 500
        elseif main.difficulty == 2 then
          player.score = player.score + 800
        elseif main.difficulty == 3 then
          player.score = player.score + 1200
        end
      elseif act == "wrong" then
        
        flags.newDest = true
        flags.renewTime = true
        flags.quake = true
        _loc.quakeTime = 10
        flags.sound.downScore = true
        gameFunc.playSound()
        
        if main.difficulty >= 1 then
          player.score = player.score - 250
        elseif main.difficulty >= 2 then
          player.score = player.score - 400
        elseif main.difficulty >= 3 then
          player.score = player.score - 600
        end
      end
      
    end
    
    if main.flags.debug.tools then
      if key == "q" then
        player.dead = false
      end
      if love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl") then
        if key == "up" then
          _loc.levelCheck.claimed = _loc.levelCheck.claimed + 1
        elseif key == "down" then
          _loc.levelCheck.claimed = _loc.levelCheck.claimed - 1
        end
      end
    end
    
    if key == "return" then
      flags.renewTime = true
    end
    
    if key == "escape" then
      if flags.paused then
        flags.paused = false
      else
        flags.paused = true
      end
    end
    
  end
  
  else
    
    if key == "backspace" then
        
        _loc.username[_loc.usernameIndex] = ""
        if _loc.usernameIndex > 1 then
          _loc.usernameIndex = _loc.usernameIndex - 1
        end
        
    elseif key == "return" then
      
      flags.confirmSubmit = true
      
    else
      
      local keyConverted
      
      local key = string.upper(key)
      
      _loc.username[_loc.usernameIndex] = key
      if _loc.usernameIndex < 6 then
        _loc.usernameIndex = _loc.usernameIndex + 1
      end
      
    end
  
  end
  
end

function mathMap(x, y)
  
  funcVar.game.mathMap_calls = funcVar.game.mathMap_calls + 1
  
	if map[(player.grid_y / _loc.cellSize) + y][(player.grid_x / _loc.cellSize) + x] == 0 or map[(player.grid_y / _loc.cellSize) + y][(player.grid_x / _loc.cellSize) + x] == 6 then
		return true
	elseif map[(player.grid_y / _loc.cellSize) + y][(player.grid_x / _loc.cellSize) + x] == 2.0 then
    player.grid_y = 128
    player.grid_x = 640
  elseif map[(player.grid_y / _loc.cellSize) + y][(player.grid_x / _loc.cellSize) + x] == 2.1 then
    player.grid_y = 128
    player.grid_x = 160
  elseif map[(player.grid_y / _loc.cellSize) + y][(player.grid_x / _loc.cellSize) + x] == 2.2 then
    player.grid_y = 416
    player.grid_x = 640
  elseif map[(player.grid_y / _loc.cellSize) + y][(player.grid_x / _loc.cellSize) + x] == 2.3 then
    player.grid_y = 416
    player.grid_x = 160
  end
	return false
end

function gameRandom(x, y, z, w)
  math.randomseed(69 * os.clock() + main.randomEnsurer * z)
  
  local a
  
  if w then
    a = math.floor(math.random(x, y) * w)
  else
    a = math.random(x, y)
  end

  funcVar.game.gameRandom_calls = funcVar.game.gameRandom_calls + 1

  return a

end

function playerAct()

  if player.grid_x == positions.X[GNL.current] then
    if player.grid_y == positions.Y[GNL.current] then
      points[GNL.current] = false
      _loc.levelCheck.claimed = _loc.levelCheck.claimed + 1
      return "right"
    end
  elseif map[(player.grid_y / _loc.cellSize)][(player.grid_x / _loc.cellSize)] == 6 then
    return "wrong"
  end
  
  return "not"
  
end

function game.unload()

end

function gameFunc.newPoint()
  
  funcVar.game.newPoint_calls = funcVar.game.newPoint_calls + 1
  
  _loc.a = 0
  local count = 1
  while count <= 29 do
    count = count + 1
    _loc.a = gameRandom(1, 24, funcVar.game.gameRandom_calls)
    if points[_loc.a] then
      return _loc.a
    end
  end
  return false
  
end

function gameFunc.newGhostDest()
  
  funcVar.game.newGhostDest_calls = funcVar.game.newGhostDest_calls + 1
  
  local r, b, o, g
  
  r = gameRandom(1, 24, funcVar.game.newGhostDest_calls+1)
  b = gameRandom(1, 24, funcVar.game.newGhostDest_calls/2)
  o = gameRandom(1, 24, funcVar.game.newGhostDest_calls*3)
  g = gameRandom(1, 24, funcVar.game.newGhostDest_calls-4)
  
  return r, b, o, g
  
end

function gameFunc.renewTime()
  
  flags.newDest = true
  
  if main.difficulty >= 1 then
    player.time = 30
  end
  
  if main.difficulty >= 2 then
    player.time = 20
  end
  
  if main.difficulty >= 3 then
    player.time = 10
  end
  
  if not flags.ghostOut then
    flags.ghostOut = true
  end

end

function gameFunc.funcQuake()
  
  funcVar.game.funcQuake_calls =   funcVar.game.funcQuake_calls + 1
  _loc.quake = gameRandom(-15, 15, funcVar.game.funcQuake_calls)
  _loc.quakeTime = _loc.quakeTime - 1
  
end

function gameFunc.playSound()
  
  if main.flags.options.playSounds then
    
    if flags.sound.normal then
      
    end
    
    if flags.sound.upScore then
      sounds.scoreIncrease:play()
      flags.sound.upScore = false
    end
    
    if flags.sound.downScore then
      sounds.scoreDecrease:play()
      flags.sound.downScore = false
    end
    
    if flags.sound.death then
      sounds.death:play()
      flags.sound.death = false
    end
    
  end
  
  if main.flags.options.playMusic then
    
    if flags.sound.song then
      
    end
    
  end
  
end

function gameFunc.newLevel(x)
  
  if not x then 
    x = 2
    flags.levelTransition = true
    _loc.levelTransition_count = 3
    main.difficulty = main.difficulty + 0.2
    flags.reload = true
    flags.rollPoints = true
    flags.restartRollControl = true
    flags.newPoint = true
  end
  
  while 1 < x do
    player.level = player.level + 1
    _loc.levelColor = 1
    _loc.levelColorCheck = _loc.levelColorCheck + 2
    flags.reload = true
    main.difficulty = main.difficulty + 0.2
    x = x - 1
  end
  
  local index = 24
  while index > 0 do
    points[index] = true
    index = index - 1
  end

end

return game