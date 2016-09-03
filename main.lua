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
end

function love.load()
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

	if (char.life <= 0) then
		world:remove(char)
		char.life = "dead"
		return "dead"

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

function endState(winner)
	love.graphics.printf("This text is aligned center",100, 100, 200,"center")
	-- stop game and wait for space key to start again
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
		endState(winner)
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
	end
end

function drawChar(char)
	if (char.charType == "castle") then
		love.graphics.setColor(255, 255, 255, 70)
		love.graphics.rectangle("fill", char.x, char.y, char.width, char.height)
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
