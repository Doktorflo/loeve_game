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
