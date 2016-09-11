bump = require 'bump'
local layout = require 'layout'
local initVariables = require 'initVariables'
local controller = require 'controller'

function initWorld()
	-- world
	world = bump.newWorld()
	-- entity table
	chars = {}
	-- castles
	heroCastle = {x=heroCastleX, y=castleY, width=castleWidth, height=castleHeight, life=lifeCastle, speed=speedCastle, party="hero", charType="castle"}
	enemyCastle = {x=enemyCastleX, y=castleY, width=castleWidth, height=castleHeight, life=lifeCastle, speed=speedCastle, party="enemy", charType="castle"}
	addChar(heroCastle)
	addChar(enemyCastle)
	timeTillDeath = 0
	counter = 0
end

function love.load()
	initWorld()
end

function addAnimation(char, charType)
	-- add a animation to a char
	-- known Image char
	local charType = char.charType
	local charLife = char.life


	-- get specific animation image
	-- TODO more status types
	-- all images
	animationHaltImages = {{"castle", castleLifeImg}}
	animationDeathImages = {{"castle" , castleDeathImg}}

	-- set the variables with the appropiate tables for animation
	for  index,value in  pairs(animationHaltImages) do
		--print(i, animationHaltImages[i], animationHaltImages.i)
		--print(index,value[1], charType)
		if value[1] == charType then
			print("halt")
			--print(i, animationHaltImages.i)
			animationHaltImage = value[2]
		end
	end
	print("baum", animationHaltImage)

	for index, value in  pairs(animationDeathImages) do
		if value[1] == charType then
			--print("deathi")
			animationDeathImage = value[2]
		end
	end

	imageGapHalt= charLife/#animationHaltImage
	imageGapDeath = charLife/#animationDeathImage

	position = 1
	latestImage = animationHaltImage[position]
	
	-- add animation properties
	char.status = "castle"
	-- based on life, threshold is needed to change image, gap is neeed to calculate new threshold
	-- ??????? maybe absolute timer without life calculation and so on?
	char.timerLife =  {["gap"] = imageGapHalt, ["threshold"] = charLife - imageGapHalt, }
	-- generic timer to count for 4 images (death)
	char.genericTimer4 = {12, position} 
	char.image = latestImage
	-- posiiton in list
	char.halt = {["imageLoop"] = animationHaltImage, ["position"] = position}
	char.death = {["imageLoop"] = animationDeathImage, ["position"]  = position}
end

function animationTimer(char)
	-- organizes image selection and status changing
	local genericTimer = char.genericTimer4
	local genericTimerMax = genericTimer[1]
	local genericTimerPosition = genericTimer[2]

	-- position increment
	genericTimer[2] = genericTimer[2] + 1
	--
	-- is position and intTimer the same --> reset position
	if genericTimerMax == genericTimer[2] then
		--print(char.charType, char.status, "bauuuu")
		-- image change
		genericTimer[2] = 1

		if char.status == "castle" then
			if char.life <= char.timerLife.threshold then
				-- set new threshold
				char.timerLife.threshold = char.life - char.timerLife.gap
				
				-- set new image
				char.halt.position = char.halt.position + 1
				if char.halt.position  == #char.halt.imageLoop then --  last image in list
					char.halt.position = 1 -- set halt position to 1
				end
				-- set correct image
				char.image =  char.halt.imageLoop[char.halt.position]
			end


		end
		if char.status == "halt" then -- stop
			-- look after timerLife or timerGeneric --> is new image needed?
			-- set new timer / timer
			-- Get incremented image from image table
			-- save image in char.image
		end

		if char.status == "run" then
		end

		if char.status == "fight" then
		end

		if char.status == "hurt" then
		end

		if char.status == "dead" then
			-- position in list
			-- increment death position in char.death
			-- increment image 
			char.death.position = char.death.position + 1
			if char.death.position  == #char.death.imageLoop then --  last image in list
				char.death.position = 1 -- set death position to 1
			end
			-- set correct image
			char.image =  char.death.imageLoop[char.death.position]
		end
end
-- add animation (images) table to char
	-- animation = {"halt" : {active: castleActive, img: castleLifeimg, treshold: -- leben für nächstes Bild, distance -- abstand der zum timer hinzugefüt wird}}
	--  "halt, start, death"
	--section = life / countOfImg
	--return section
end


function changeStatus(char, newStatus)
	char.status = newStatus
end
-- table for all elements to draw them
function addChar(arg)
	-- life reduces by collision
	-- different speed for movement
	-- differnt images for each charType
	-- just different parties can attack
	--x, y, width, height, life, speed, party, charType)
	local char = arg
	-- add character to table for all chars
	chars[#chars + 1] = char
	-- add character to world for bump
	addAnimation(char)
	world:add(char, char.x, char.y, char.width, char.height)
end

function updateChars(dt)
	for index, char in ipairs(chars) do
		updateChar(char, dt) -- change properties
		-- status set??
		animationTimer(char)
		--TODO
		remove = deathHandler(char)
		-- TODO death timer how long should it be alive?
		if (remove == true) then
			--print(index, char)
			--print("dead")
			table.remove(chars, index)
		end

		-- changes gameStatus
		checkWinState(char)
	end
end

function deathHandler(char)
	-- TODO
	-- Check character death
	if (char.life <= 0) then
		char.status = "dead"
	end

	if char.status == "dead" then
		-- remove char from world
		-- castles shouln´t be removed from world
		if char.charType ~= "castle" then
			print(char.charType)
			world:remove(char)
			return true
		--return false
		end
	end
end
function updateChar(char, dt)
	local speed = char.speed
	local charType = char.charType
	local party = char.party
	local life = char.life
	local status = char.status

	--print(speed, charType, party, life, status)
	-- After Deathcounter: Game lost

	--if(timeTillDeath == 20) and (charType == "castle") and (char.life <= 0)then
	--world:remove(char)
	--	char.life = "dead"
	--	return "dead"
	--else
	--end



	---- castleLife

	--if (charType == "castle" and party == "enemy") then
	--castleLife = life
	--elseif (charType == "castle" and party == "hero") then
	--castleLifehero = life
	--end

	-- calculate new position
	if (party == "hero") then
		-- move right
		distance = speed * dt
	elseif (party == "enemy") then
		--- move left
		distance = -speed * dt
	end

	local cols

	-- create filter
	local heroFilter = function(item, other)
		if (other.party ~= char.party) then return "touch"
		elseif (other.party == char.party) then return "cross"
		end
	end

	-- move char
	char.x, char.y, cols, cols_len = world:move(char, char.x + distance, char.y, heroFilter)
	-- collsion detection
	for i=1, cols_len do
		local other = cols[i].other
		if (other.party ~= char.party) then
			-- remove life
			other.life = other.life - 10
			char.life = char.life - 10

		end
	end
end

function endState()
	-- winner must be set from checkWinState
	love.graphics.setNewFont(endStateFont)
	if (winner == "hero") then
		print("herogame has ended")
		love.graphics.printf("The left player won the game",screenW, screenH, 200,"center")
	elseif (winner == "enemy") then
		print(middleX)
		print(middleY)
		print("enemygame has ended")
		love.graphics.printf("The right player won the game",0, middleY ,screenW, "center")
	end
	love.graphics.setNewFont(defaultFontSize)
	-- stop game and wait for enter key to start again
end

function checkWinState(char)
	-- check for end of game
	if char.charType == "castle" then
		if char.life <= 0 then
			if char.party == "hero" then
				gameStatus = "gameover"
				winner = "hero"
			elseif char.party == "enemy" then
				gameStatus = "gameover"
				winner = "enemy"
			end

		end
	end
end
function inScreen(x, y)
	-- checks if coordinates are in the screen
	-- minumum
	local x = x
	local y = y
	if (x < 0) or (y < 0) then
		return false
	else return true
	end
	-- maximum
	if (x < screenW) or (y < screenH) then
		return false
	else
		return true
	end

end

-- helper function
function drawMap()
	-- map
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(bg)
end

function drawChars()
	for _, char in ipairs(chars) do
		drawChar(char)
		drawStatus(char)
	end
end

function drawChar(char)
	if (char.charType == "castle") then
		if char.party == "hero" then
			love.graphics.setColor(190, 250, 190, 255)
			love.graphics.draw(char.image, 50, 250, 0, 1, 1)
		elseif char.party == "enemy" then
			--print(char.image)
			love.graphics.setColor(255, 100, 100, 150)
			love.graphics.draw(char.image, 650, 250, 0, 1, 1)

		end
		love.graphics.setColor(255, 255, 255, 150)
		--love.graphics.setColor(255, 255, 255, 70)
		--love.graphics.rectangle("fill", char.x, char.y , char.width, char.height)

		--
		-- enemycastle
		--if (castleLife < 0) then
		--	elseif (castleLife <= 100) then
		--	castleActive = castle_19
		--	elseif (castleLife <= 200) then
		--	castleActive = castle_18
		--	elseif (castleLife <= 300) then
		--	castleActive = castle_17
		--	elseif (castleLife <= 400) then
		--	castleActive = castle_16
		--	elseif (castleLife <= 500) then
		--	castleActive = castle_15
		--	elseif (castleLife <= 600) then
		--	castleActive = castle_14
		--	elseif (castleLife <= 700) then
		--	castleActive = castle_13
		--	elseif (castleLife <= 800) then
		--	castleActive = castle_12
		--	elseif (castleLife <= 900) then
		--	castleActive = castle_11
		--	elseif (castleLife <= 1000) then
		--	castleActive = castle_10
		--	elseif (castleLife <= 1100) then
		--	castleActive = castle_09
		--	elseif (castleLife <= 1200) then
		--	castleActive = castle_08
		--	elseif (castleLife <= 1300) then
		--	castleActive = castle_07
		--	elseif (castleLife <= 1400) then
		--	castleActive = castle_06
		--	elseif (castleLife <= 1500) then
		--	castleActive = castle_05
		--	elseif (castleLife <= 1600) then
		--	castleActive = castle_04
		--	elseif (castleLife <= 1700) then
		--	castleActive = castle_03
		--	elseif (castleLife <= 1800) then
		--	castleActive = castle_02
		--	elseif (castleLife <= 1900) then
		--	castleActive = castle_01
		--	elseif (castleLife <= 2000) then
		--	castleActive = castle_00
		--end

		--if (castleLife < 0) then
		--	if (counter > 500) then
		--		castleActive = castle_20
		--	elseif (counter > 400) then
		--		castleActive = castle_21
		--	elseif (counter > 300) then
		--		castleActive = castle_22
		--	elseif (counter > 200) then
		--		castleActive = castle_23
		--	elseif (counter > 100) then
		--		castleActive = castle_24
		--	elseif (counter > 0) then
		--		castleActive = castle_25
		--	end

		--	if (counter > 600) then
		--			counter = 0
		--			timeTillDeath = timeTillDeath + 1
		--	end
		--counter = counter + animationSpeed
		--end
		--love.graphics.setColor(255, 100, 100, 150)
		--love.graphics.draw(castleActive, 650, 250, 0, 1, 1)
		--love.graphics.setColor(255, 255, 255, 150)
		--love.graphics.print("Counter:  " ..counter, 200, 30)

		---- herocastle

		--if (castleLifehero < 0) then
		--	elseif (castleLifehero <= 100) then
		--	castleActive = castle_19
		--	elseif (castleLifehero <= 200) then
		--	castleActive = castle_18
		--	elseif (castleLifehero <= 300) then
		--	castleActive = castle_17
		--	elseif (castleLifehero <= 400) then
		--	castleActive = castle_16
		--	elseif (castleLifehero <= 500) then
		--	castleActive = castle_15
		--	elseif (castleLifehero <= 600) then
		--	castleActive = castle_14
		--	elseif (castleLifehero <= 700) then
		--	castleActive = castle_13
		--	elseif (castleLifehero <= 800) then
		--	castleActive = castle_12
		--	elseif (castleLifehero <= 900) then
		--	castleActive = castle_11
		--	elseif (castleLifehero <= 1000) then
		--	castleActive = castle_10
		--	elseif (castleLifehero <= 1100) then
		--	castleActive = castle_09
		--	elseif (castleLifehero <= 1200) then
		--	castleActive = castle_08
		--	elseif (castleLifehero <= 1300) then
		--	castleActive = castle_07
		--	elseif (castleLifehero <= 1400) then
		--	castleActive = castle_06
		--	elseif (castleLifehero <= 1500) then
		--	castleActive = castle_05
		--	elseif (castleLifehero <= 1600) then
		--	castleActive = castle_04
		--	elseif (castleLifehero <= 1700) then
		--	castleActive = castle_03
		--	elseif (castleLifehero <= 1800) then
		--	castleActive = castle_02
		--	elseif (castleLifehero <= 1900) then
		--	castleActive = castle_01
		--	elseif (castleLifehero <= 2000) then
		--	castleActive = castle_00
		--end

		--if (castleLifehero < 0) then
		--	if (counter > 500) then
		--		castleActive = castle_20
		--	elseif (counter > 400) then
		--		castleActive = castle_21
		--	elseif (counter > 300) then
		--		castleActive = castle_22
		--	elseif (counter > 200) then
		--		castleActive = castle_23
		--	elseif (counter > 100) then
		--		castleActive = castle_24
		--	elseif (counter > 0) then
		--		castleActive = castle_25
		--	end

		--	if (counter > 600) then
		--			counter = 0
		--			timeTillDeath = timeTillDeath + 1
		--	end
		--counter = counter + animationSpeed
		--end
		--love.graphics.setColor(255, 255, 255, 150)
		--love.graphics.print("Counter:  " ..counter, 200, 30)

	elseif (char.charType == "rock") then
		love.graphics.setColor(0, 255, 255, 150)
		--love.graphics.circle("fill", char.x, char.y, char.height/2, 4)
		love.graphics.rectangle("fill", char.x, char.y, char.width, char.height)
	elseif (char.charType == "paper") then
		love.graphics.setColor(255, 0, 255, 150)
		love.graphics.rectangle("fill", char.x, char.y, char.width, char.height)
		--love.graphics.circle("fill", char.x, char.y, char.height/2, 500)
	elseif (char.charType == "scissors") then
		love.graphics.setColor(255, 255, 0, 150)
		love.graphics.rectangle("fill", char.x, char.y, char.width, char.height)
		--love.graphics.circle("fill", char.x, char.y, char.height/2, 3)
		--love.graphics.polygon('fill', 100, 100, 200, 100, 150, 200)
	else
		print(char.charType)
		print("nil")
	end
end

function drawStatus(char)
	-- draws life of the castles
	love.graphics.setColor(0, 0, 0, 70)
	if char.charType == "castle" then
		if char.party == "hero" then
			love.graphics.print("hero life:  " .. char.life, 50, 30)
		elseif char.party == "enemy" then
			love.graphics.print("enemy life  " .. char.life, 600, 30)
		end
	end
end

function removeWorld()
	-- delete all chars in the world
	chars = nil
	char = nil
end

function love.keyreleased(key)
	controller.control(key)
end

function love.update(dt)
	updateChars(dt)
end

function love.draw()
	if gameStatus == "gameover" then
		drawMap()
		drawChars()
		endState()
	else
		drawMap()
		drawChars()
	end

end
