bump = require 'bump'
local layout = require 'layout'
local initVariables = require 'initVariables'
local controller = require 'controller'
local draw = require 'draw'
local update = require 'update'
local utility = require 'utility'

function love.load()
	initWorld()
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
