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
	-- is position and intTimer the same --> reset position
	if genericTimerMax == genericTimer[2] then
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
		elseif char.status == "halt" then
			-- look after timerLife or timerGeneric --> is new image needed?
			-- set new timer / timer
			-- Get incremented image from image table
			-- save image in char.image

		elseif char.status == "run" then

		elseif char.status == "fight" then

		elseif char.status == "hurt" then

		elseif char.status == "dead" then
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
			damageCalc(other, char)
		end
	end
end

function damageCalc(other, char)
	-- remove life
	if (other.charType ~= char.charType) then
		-- castle
		if (other.charType == "castle") then
			other.life = other.life - 10
			char.life = char.life - 10
			print("castle")
		else 
			-- scissors, stone, paper
			char.charType = hT
			other.charType = eT
			if (ht == "scissors" and et == "paper" or ht == "paper" and et == "rock" or ht == "rock" and et == "scissors") then
				-- effective
				print("effective")
				char.life = char.life - 5
				other.life = other.life - 20
			elseif (ht == scissors and et == "rock" or ht == "paper" and et == "scissors" or ht == "scissors" and et == "paper") then
				-- not effective
				print("not effective")
				char.life = char.life - 20
				other.life = other.life - 5
			end
		end

	else
		-- same charType, normal
		other.life = other.life - 8
		char.life = char.life - 8
	end
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
