local layout = require 'layout'
local initVariables = require 'initVariables'
local controller = {}

-- status variables
HeroLane = 0
EnemyLane = 0

HeroCharType = 0
EnemyCharType = 0

HeroLaneVar = secondLaneY
EnemyLaneVar = secondLaneY

HeroCharTypeVar = heroCharType
EnemyCharTypeVar = enemyCharType

-- firstLane/rock --> 1
-- secondLane/paper --> 0
-- thirdLane/scissors --> -1

HeroLife = lifeRock
EnemyLife = lifeRock

HeroSpeed = speedRock
EnemySpeed = speedRock

function countChanger(latestValue, posOrNegative)
	-- changes latestVariables in a range between -1 and 1 (three) values
	--
	-- alternative boolean with nil
	if latestValue == 1 then
		if posOrNegative == 1 then
			-- maximum reached
			return 1
		elseif posOrNegative == -1 then
			-- decrement 1
			return 0
		end

	elseif latestValue == 0 then
		if posOrNegative == 1 then
			-- increment 1
			return 1
		elseif posOrNegative == -1 then
			-- decrement 1
			return -1
		end

	elseif latestValue == -1 then
		if posOrNegative == 1 then
			-- increment 1
			return 0
		elseif posOrNegative ==  -1 then
			-- min reached
			return -1
		end
	end
end

function origin(key)
	-- is key from the hero or the enemy?
	local heroKeys = {w=true,a=true,s=true,d=true,q=true}
	local enemyKeys = {i=true,j=true,k=true,l=true,u=true}

	if heroKeys[key] ~= nil then
		return "hero"
	elseif enemyKeys[key] ~= nil then
		return "enemy"
	else
		return false
	end
end

function laneOrCharTypeKey(key)
	-- detect if key is for lane or charType
	keyType = nil
	local laneKeys = {w=true,s=true,i=true,k=true}
	local charTypeKeys =  {a=true, d=true, j=true, l=true}
	if laneKeys[key] ~= nil then
		keyType = "lane"
		return keyType
	elseif charTypeKeys ~= nil then
		keyType = "charType"
		return keyType
	else
		return nil
	end
end

function counterToVariables(value, laneOrCharTypeArg)
	-- translates between the Counter (three values) to the specific variable, possibly glovbal values
	local value = value
	local laneOrCharTypeArg = laneOrCharTypeArg
	if laneOrCharTypeArg == "lane" then
		print("lane")
		if (value == 1) then
			return firstLaneY
		elseif (value == 0) then
			return secondLaneY
		elseif (value == -1) then
			return thirdLaneY
		end
	elseif laneOrCharTypeArg == "charType" then
		if (value == 1) then
			-- lifeRock speedRock
			return "rock", lifeRock, speedRock
		elseif (value == 0) then
			return "paper", lifePaper, speedPaper
		elseif (value == -1) then
			return "scissors", lifeScissor, speedScissor
		end
	else return nil
	end
end

function upOrDownKey(key)
	-- detect if key is for up or down position or left(-1) or right(+)
	local keyType = nil
	local positive = {w=true,i=true,d=true,l=true}
	local negative =  {s=true, k=true, a=true, j=true}

	if positive[key] ~= nil then
		return 1
	elseif negative[key] ~= nil then
		return -1
	else return nil
	end
end

function actionKey(key)
	yes = {q=true, u=true}
	if yes[key] ~= nil then
		return true
	else return false
	end
end

function addCharWrapper(key, heroOrEnemy, laneOrCharTypeRelevant, upOrDownKeyRelevant, actionRelevant)
	if upOrDownKeyRelevant == nil then
		-- it should be an action key
		-- creation
		if actionRelevant then

			if (heroOrEnemy == "hero") then
				addChar({x=heroStartX, y=HeroLaneVar, width=heroOrEnemyWidth, height=heroOrEnemyHeight, life=HeroLife, speed=HeroSpeed, party="hero", charType=HeroCharTypeVar})
			elseif (heroOrEnemy == "enemy") then
				addChar({x=enemyStartX, y=EnemyLaneVar, width=heroOrEnemyWidth, height=heroOrEnemyHeight, life=EnemyLife, speed=EnemySpeed, party="enemy", charType=enemyCharType})
			end

		end
	else
		if heroOrEnemy == "hero" then
			if laneOrCharTypeRelevant == "lane" then
				-- sets firstLine, secondLane and third Lane accordingly
				--print(key, heroOrEnemy, laneOrCharTypeRelevant, upOrDownKeyRelevant, actionRelevant)
				HeroLane = countChanger(HeroLane, upOrDownKeyRelevant)
				HeroLaneVar = counterToVariables(HeroLane, "lane")
			elseif laneOrCharTypeRelevant == "charType" then
				-- sets rock, paper and scissors and their life and speed from the global variables
				HeroCharType = countChanger(HeroCharType, upOrDownKeyRelevant)
				HeroCharTypeVar, HeroLife, HeroSpeed = counterToVariables(HeroCharType, "charType")
			end
		elseif heroOrEnemy == "enemy" then
			if laneOrCharTypeRelevant == "lane" then
				-- sets firstLine, secondLane and third Lane accordingly
				EnemyLane = countChanger(EnemyLane, upOrDownKeyRelevant)
				EnemyLaneVar = counterToVariables(EnemyLane, "lane")
			elseif laneOrCharTypeRelevant == "charType" then
				-- sets rock, paper and scissors and their life and speed from the global variables
				EnemyCharType = countChanger(EnemyCharType, upOrDownKeyRelevant)
				EnemyCharTypeVar, EnemyLife, EnemySpeed = counterToVariables(EnemyCharType, "charType")
			end
		end
	end
end

function controller.control(key)
	local heroOrEnemyRelevant = origin(key)
	local laneOrCharTypeRelevant = laneOrCharTypeKey(key)
	local upOrDownKeyRelevant = upOrDownKey(key)
	local actionRelevant = actionKey(key)

	if (origin(key) ~= false) then
		addCharWrapper(key, heroOrEnemyRelevant, laneOrCharTypeRelevant, upOrDownKeyRelevant, actionRelevant)
	end

	-- exit game
	if (key == "escape") then
		love.event.quit()
	end
	-- restart game if it has ended
	if (gameStatus =="gameover") then
		if (key == "space") then
			-- reset variables and start anew
			gameStatus = "active"
			-- restart world
			removeWorld()
			initWorld()
		end
	end
end

return controller
