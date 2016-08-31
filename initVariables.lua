-- init variables to change values quickly

-- game status and default values
gameStatus = "active"
-- default charTypes
heroCharType = "square"
enemyCharType = "square"

--  images and sprites
-- map
bg = love.graphics.newImage("map1.png")

--sprites

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
