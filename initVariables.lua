-- init variables to change values quickly

-- game status and default values
gameStatus = "active"
-- default charTypes
heroCharType = "rock"
enemyCharType = "rock"

--  images and sprites
-- map
bg = love.graphics.newImage("map1.png")

-- images
-- init pictures
castleImg = {}
for i=0,25 do
	print(i)
	castleImg[i] = love.graphics.newImage("assets/img/castle/castle"..i..".png")
end
--
for i=1,#castleImg do
	print(i, castleImg[i])
end
--castle_00 = love.graphics.newImage("assets/img/castle/castle0.png")

--castle_00 = love.graphics.newImage("assets/img/castle0.png")
--castle_01 = love.graphics.newImage("assets/img/castle1.png")
--castle_02 = love.graphics.newImage("assets/img/castle2.png")
--castle_03 = love.graphics.newImage("assets/img/castle3.png")
--castle_04 = love.graphics.newImage("assets/img/castle4.png")
--castle_05 = love.graphics.newImage("assets/img/castle5.png")
--castle_06 = love.graphics.newImage("assets/img/castle6.png")
--castle_07 = love.graphics.newImage("assets/img/castle7.png")
--castle_08 = love.graphics.newImage("assets/img/castle8.png")
--castle_09 = love.graphics.newImage("assets/img/castle9.png")
--castle_10 = love.graphics.newImage("assets/img/castle10.png")
--castle_11 = love.graphics.newImage("assets/img/castle11.png")
--castle_12 = love.graphics.newImage("assets/img/castle12.png")
--castle_13 = love.graphics.newImage("assets/img/castle13.png")
--castle_14 = love.graphics.newImage("assets/img/castle14.png")
--castle_15 = love.graphics.newImage("assets/img/castle15.png")
--castle_16 = love.graphics.newImage("assets/img/castle16.png")
--castle_17 = love.graphics.newImage("assets/img/castle17.png")
--castle_18 = love.graphics.newImage("assets/img/castle18.png")
--castle_19 = love.graphics.newImage("assets/img/castle19.png")
---- lost castles
--castle_20 = love.graphics.newImage("assets/img/castle20.png")
--castle_21 = love.graphics.newImage("assets/img/castle21.png")
--castle_22 = love.graphics.newImage("assets/img/castle22.png")
--castle_23 = love.graphics.newImage("assets/img/castle23.png")
--castle_24 = love.graphics.newImage("assets/img/castle24.png")
--castle_25 = love.graphics.newImage("assets/img/castle25.png")

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
