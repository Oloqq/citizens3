local MainGame = GameScreen:extend()

local config = config
local love = love
local gr = love.graphics

function MainGame:load(args)
	self.map = Map()
	self.map:load('maps/maptest')
end

function MainGame:update(dt)
	self.map:update(dt)
end

function MainGame:draw()
	self.map:draw()
end

return MainGame