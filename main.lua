platform = {}
characters = {}
burg = {}

-- Timers
canShootRed = true
canShootBlue = true
canShootTimerMax = 0.2
canShootTimer = canShootTimerMax

rectanglesRed = {} -- entity pool red
rectanglesBlue = {} -- entity pool blau
rectanglesImgRed = nil
rectanglesImgBlue = nil
function  love.load()
		-- dont hurt me
		rectanglesImgRed = love.graphics.newImage("RedRectangle.png")
		rectanglesImgBlue = love.graphics.newImage("BlueRectangle.png")
		
		-- game world
		platform.width = love.graphics.getWidth()
		platform.height = love.graphics.getHeight()
		love.graphics.setBackgroundColor(200,200,200)
		
		platform.x = 0
		platform.y = platform.height / 2
		
		--rot
		platform.laufy = platform.y + 32
		platform.laufx = platform.x + 32
		
		--blau
		platform.laufyBlue = platform.y + 32
		platform.laufxBlue = platform.width - 32
		
		-- game world objects

		burg.startImg = love.graphics.newImage("CastleHuge.png")
		
		-- game character
		platform.x = love.graphics.getWidth() / 2
		platform.y = love.graphics.getHeight() / 2
		characters.pos_x = 0
		characters.mennekenRed = love.graphics.newImage("RedRectangle.png")
		characters.mennekenBlue = love.graphics.newImage("BlueRectangle.png")
		
		
end

function  love.update(dt)
		require("lurker").update()
		-- Timer
		canShootTimer = canShootTimer - (1 *dt)
		if canShootTimer < 0 then
			canShootRed = true
			canShootBlue = true
		end
		move()
		
		-- rote
		
		if love.keyboard.isDown("w") and canShootRed then
			-- dont hurt me.. no more
			newRechteck = {  x = platform.laufx , y = platform.laufy, img = rectanglesImgRed}
			table.insert(rectanglesRed, newRechteck)
			canShootRed = false
			canShootTimer = canShootTimerMax
		end
		
		for i, rectangle in ipairs(rectanglesRed) do
			rectangle.x = rectangle.x + (250 *dt)
			
			if rectangle.x < 0 then
				table.remove(rectanglesRed, i)
			end
		end
		
		-- blaue
		
		if love.keyboard.isDown("s") and canShootBlue then
			-- dont hurt me.. no more.. vodka
			newRechteck = {  x = platform.laufxBlue , y = platform.laufyBlue, img = rectanglesImgBlue}
			table.insert(rectanglesBlue, newRechteck)
			canShootBlue = false
			canShootTimer = canShootTimerMax
		end
		
		for i, rectangle in ipairs(rectanglesBlue) do
			rectangle.x = rectangle.x - (250 *dt)
			
			if rectangle.x < 0 then
				table.remove(rectanglesBlue, i)
			end
		end
		
		--[[for i, rectangleRed in ipairs(rectanglesRed) do
			for i, rectangleBlue in ipairs(rectanglesBlue) do
				if rectangleRed.x == rectangleBlue.x then
			
					table.remove(rectanglesBlue, i)
					table.remove(rectanglesRed, i)
				end
			end
		end
		--]]
end

function love.draw()
	--love.graphics.print("Hello World!", 400, 300)
	love.graphics.setColor(255,255,255)
	love.graphics.draw(burg.startImg, 0, platform.y, 0, 1, 1)
	
	--important all-seeing red rectangle wich controlls the world and everything 
	love.graphics.draw(characters.mennekenRed, characters.pos_x, platform.lauf, 0, 4, 4)
	
	-- welt
	love.graphics.setColor(58, 68, 58)
	love.graphics.rectangle('fill', 0, platform.y+64, platform.width, platform.height)
	
	love.graphics.setColor(255,255,255)
	for i, rectangle in ipairs(rectanglesRed) do
		love.graphics.draw(rectangle.img, rectangle.x, rectangle.y)
	end
	for i, rectangle in ipairs(rectanglesBlue) do
		love.graphics.draw(rectangle.img, rectangle.x, rectangle.y)
	end
end

function move()

	characters.pos_x = characters.pos_x + 1
	

end