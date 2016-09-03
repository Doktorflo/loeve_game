-- init variables to change values quickly

-- game status and default values
gameStatus = "active"
-- default charTypes
heroCharType = "rock"
enemyCharType = "rock"

--  images and sprites
-- map
bg = love.graphics.newImage("map1.png")

--sprites
-- init pictures
castle_00 = love.graphics.newImage("Burg00.png")
castle_01 = love.graphics.newImage("Burg01.png")
castle_02 = love.graphics.newImage("Burg02.png")
castle_03 = love.graphics.newImage("Burg03.png")
castle_04 = love.graphics.newImage("Burg04.png")
castle_05 = love.graphics.newImage("Burg05.png")
castle_06 = love.graphics.newImage("Burg06.png")
castle_07 = love.graphics.newImage("Burg07.png")
castle_08 = love.graphics.newImage("Burg08.png")
castle_09 = love.graphics.newImage("Burg09.png")
castle_10 = love.graphics.newImage("Burg10.png")
castle_11 = love.graphics.newImage("Burg11.png")
castle_12 = love.graphics.newImage("Burg12.png")
castle_13 = love.graphics.newImage("Burg13.png")
castle_14 = love.graphics.newImage("Burg14.png")
castle_15 = love.graphics.newImage("Burg15.png")
castle_16 = love.graphics.newImage("Burg16.png")
castle_17 = love.graphics.newImage("Burg17.png")
castle_18 = love.graphics.newImage("Burg18.png")
castle_19 = love.graphics.newImage("Burg19.png")
-- lost castles
castle_20 = love.graphics.newImage("Burg20.png")
castle_21 = love.graphics.newImage("Burg21.png")
castle_22 = love.graphics.newImage("Burg22.png")
castle_23 = love.graphics.newImage("Burg23.png")
castle_24 = love.graphics.newImage("Burg24.png")
castle_25 = love.graphics.newImage("Burg25.png")

castleActive = castle_00


counter = 0
timeTillDeath = 0
animationSpeed = 15

-- variables for characters
speedDefault = 10
lifeDefault = 100
speed = speedDefault
life = lifeDefault


speedCastle  = 0
speedRock    = 100
speedPaper   = 100
speedScissor = 100

lifeCastle   = 2000
lifeRock     = 10
lifePaper    = 20
lifeScissor  = 400
