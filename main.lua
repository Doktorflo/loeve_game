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
	-- Init Pictures
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
	-- Lost Castles
	castle_20 = love.graphics.newImage("Burg20.png")
	castle_21 = love.graphics.newImage("Burg21.png")
	castle_22 = love.graphics.newImage("Burg22.png")
	castle_23 = love.graphics.newImage("Burg23.png")
	castle_24 = love.graphics.newImage("Burg24.png")
	castle_25 = love.graphics.newImage("Burg25.png")
	
	castleActive = castle_00
	initWorld()
end

-- table for all elements to draw them
function addChar(arg)
	-- life reduces by collision
	-- different speed for movement
	-- differnt images for each charType
	-- just different parties can attack
	print(arg.party)
	--x, y, width, height, life, speed, party, charType)
	local char = arg
	-- add character to table for all chars
	chars[#chars + 1] = char
	print(char.charType)
	-- add character to world for bump
	world:add(char, char.x, char.y, char.width, char.height)
end

function updateChars(dt)
	for index, char in ipairs(chars) do
		status = updateChar(char, dt)
		if (status == "dead") then
			print(index, char)
			print("dead")
			table.remove(chars, index)
		end
	end
end

function updateChar(char, dt)
	local speed = char.speed
	local charType = char.charType
	local party = char.party
	local life = char.life
	

	
	-- character dead?
	if (char.life <= 0) and (charType ~= "castle")then
		world:remove(char)
		char.life = "dead"
		return "dead"
	else
	
	end
	
	-- After Deathcounter: Game lost
	
	if(timeTillDeath == 20) and (charType == "castle") and (char.life <= 0)then
	world:remove(char)
		char.life = "dead"
		return "dead"
	else
	end
	

	
	-- castlelife
	
	if (charType == "castle" and party == "enemy") then
	castlelife = life
	elseif (charType == "castle" and party == "hero") then
	castlelifehero = life
	end
	
	-- calculate new position
	if (party == "hero") then
		-- move right
		distance = speed * dt
	elseif (party == "enemy") then
		--- move left
		distance = -speed * dt
	end

	local cols
	--
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

	if (castlelife < 0) then
	love.graphics.printf("You won the game",100, 100, 200,"center")
	elseif (castlelifehero < 0) then
	love.graphics.printf("You lost the game",100, 100, 200,"center")
	end
	-- stop game and wait for enter key to start again
	print("stop")
end

function checkWinState()
	-- check for end of game
	-- if game is already in end game change game world

	--if (gameStatus == "gameover") then

	--end

	local heroCastleExist = world:hasItem(heroCastle)
	local enemyCastleExist = world:hasItem(enemyCastle)

	if (heroCastleExist ~= true or enemyCastleExist ~= true) then

		gameStatus = "gameover"
		local winner = nil
		if (heroCastleExist == true) then
			winner = "hero"
			
		else
			winner = "enemy"
			
		endState()
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
		drawStatus()
	end
end

function drawChar(char)
	if (char.charType == "castle") then
		--love.graphics.setColor(255, 255, 255, 70)
		--love.graphics.rectangle("fill", char.x, char.y , char.width, char.height)
		
		-- enemycastle
		if (castlelife < 0) then
			elseif (castlelife <= 100) then
			castleActive = castle_19
			elseif (castlelife <= 200) then
			castleActive = castle_18
			elseif (castlelife <= 300) then
			castleActive = castle_17
			elseif (castlelife <= 400) then
			castleActive = castle_16
			elseif (castlelife <= 500) then
			castleActive = castle_15
			elseif (castlelife <= 600) then
			castleActive = castle_14
			elseif (castlelife <= 700) then
			castleActive = castle_13
			elseif (castlelife <= 800) then
			castleActive = castle_12
			elseif (castlelife <= 900) then
			castleActive = castle_11
			elseif (castlelife <= 1000) then
			castleActive = castle_10
			elseif (castlelife <= 1100) then
			castleActive = castle_09
			elseif (castlelife <= 1200) then
			castleActive = castle_08
			elseif (castlelife <= 1300) then
			castleActive = castle_07
			elseif (castlelife <= 1400) then
			castleActive = castle_06
			elseif (castlelife <= 1500) then
			castleActive = castle_05
			elseif (castlelife <= 1600) then
			castleActive = castle_04
			elseif (castlelife <= 1700) then
			castleActive = castle_03
			elseif (castlelife <= 1800) then
			castleActive = castle_02
			elseif (castlelife <= 1900) then
			castleActive = castle_01
			elseif (castlelife <= 2000) then
			castleActive = castle_00
		end
		
		if (castlelife < 0) then
			if (counter > 500) then
				castleActive = castle_20 
			elseif (counter > 400) then
				castleActive = castle_21
			elseif (counter > 300) then
				castleActive = castle_22
			elseif (counter > 200) then
				castleActive = castle_23
			elseif (counter > 100) then
				castleActive = castle_24
			elseif (counter > 0) then
				castleActive = castle_25
			end
			
			if (counter > 600) then
					counter = 0
					timeTillDeath = timeTillDeath + 1
			end
		counter = counter + animationSpeed
		end
		love.graphics.setColor(255, 100, 100, 150)
		love.graphics.draw(castleActive, 650, 250, 0, 1, 1)
		love.graphics.setColor(255, 255, 255, 150)
		love.graphics.print("Counter:  " ..counter, 200, 30)
		
		-- herocastle
		
		if (castlelifehero < 0) then
			elseif (castlelifehero <= 100) then
			castleActive = castle_19
			elseif (castlelifehero <= 200) then
			castleActive = castle_18
			elseif (castlelifehero <= 300) then
			castleActive = castle_17
			elseif (castlelifehero <= 400) then
			castleActive = castle_16
			elseif (castlelifehero <= 500) then
			castleActive = castle_15
			elseif (castlelifehero <= 600) then
			castleActive = castle_14
			elseif (castlelifehero <= 700) then
			castleActive = castle_13
			elseif (castlelifehero <= 800) then
			castleActive = castle_12
			elseif (castlelifehero <= 900) then
			castleActive = castle_11
			elseif (castlelifehero <= 1000) then
			castleActive = castle_10
			elseif (castlelifehero <= 1100) then
			castleActive = castle_09
			elseif (castlelifehero <= 1200) then
			castleActive = castle_08
			elseif (castlelifehero <= 1300) then
			castleActive = castle_07
			elseif (castlelifehero <= 1400) then
			castleActive = castle_06
			elseif (castlelifehero <= 1500) then
			castleActive = castle_05
			elseif (castlelifehero <= 1600) then
			castleActive = castle_04
			elseif (castlelifehero <= 1700) then
			castleActive = castle_03
			elseif (castlelifehero <= 1800) then
			castleActive = castle_02
			elseif (castlelifehero <= 1900) then
			castleActive = castle_01
			elseif (castlelifehero <= 2000) then
			castleActive = castle_00
		end
		
		if (castlelifehero < 0) then
			if (counter > 500) then
				castleActive = castle_20 
			elseif (counter > 400) then
				castleActive = castle_21
			elseif (counter > 300) then
				castleActive = castle_22
			elseif (counter > 200) then
				castleActive = castle_23
			elseif (counter > 100) then
				castleActive = castle_24
			elseif (counter > 0) then
				castleActive = castle_25
			end
			
			if (counter > 600) then
					counter = 0
					timeTillDeath = timeTillDeath + 1
			end
		counter = counter + animationSpeed
		end
		love.graphics.setColor(190, 250, 190, 255)
		love.graphics.draw(castleActive, 50, 250, 0, 1, 1)
		love.graphics.setColor(255, 255, 255, 150)
		love.graphics.print("Counter:  " ..counter, 200, 30)

		
		
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

function drawStatus()

	love.graphics.setColor(0, 0, 0, 70)
	love.graphics.print("Gegner Leben:  " ..castlelife, 600, 30)
	love.graphics.print("Held Leben:  " ..castlelifehero, 50, 30)
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
	-- changes gameStatus
	checkWinState()
end

function love.draw()
	if gameStatus == "gameover" then
		drawMap()
		endState()
	else
		drawMap()
		drawChars()
	end

end
