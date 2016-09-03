-- init variables to change values quickly

-- game status and default values
gameStatus = "active"
-- default charTypes
heroCharType = "rock"
enemyCharType = "rock"

--  images
-- map
bg = love.graphics.newImage("assets/img/map1.png")
-- castle
castleImg = {}
for i=0,25 do
	castleImg[i] = love.graphics.newImage("assets/img/castle/castle"..i..".png")
end
castleLifeImg = {}
castleDeathImg = {}

for i=0, #castleImg do
	if i < 20 then
		castleLifeImg[#castleLifeImg +1] = castleImg[i]
	else
		castleDeathImg[#castleDeathImg +1] = castleImg[i]
	end

end

-- variables for castles
heroCastleActive = castleLifeImg[1]
enemyCastleActive = castleLifeImg[1]
-- unneeded
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
