--local layout = {}
screenW,  screenH = love.graphics.getDimensions()
local screenW = screenW
local screenH = screenH

-- build a grid system
row = screenH / 10
column = screenW / 10

heroCastleX = column
enemyCastleX = column * 8
castleY = row

castleHeight = row * 8
castleWidth = column

firstLaneY = row * 2
secondLaneY = row * 5
thirdLaneY = row * 8

heroStartX = column * 2
enemyStartX = column * 7

heroOrEnemyHeight = column/2
heroOrEnemyWidth = column/2

middleX = screenW / 2
middleY = screenH / 2
--return layout
