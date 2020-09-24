local MainGame = Screen:extend()

local config = config
local love = love
local gr = love.graphics

function MainGame:load(args)
	-- self.map = Map()
	-- self.map:load('maps/maptest')
	print('main game loaded')
end

function MainGame:resume()
	print('game resumed')
end

function MainGame:update(dt)
	-- self.map:update(dt)
end

function MainGame:draw()
	-- self.map:draw()
end

function MainGame:keypressed(key)
	setScreen('menu')
end

return MainGame