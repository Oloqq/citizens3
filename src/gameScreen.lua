local MainGame = Screen:extend()

local config = config
local love = love
local gr = love.graphics

local Camera = require("deps/camera")
local Map = require("src/map/map")

function MainGame:load(args)
	self.camera = Camera()
	self.map = Map('maps/maptest')
	print('main game loaded')
end

function MainGame:resume()
	print('game resumed')
end

function MainGame:update(dt)
	self.camera:update(dt)
	self.map:update(dt)
end

function MainGame:draw()
	self.camera:set()
	self.map:draw()
	self.camera:unset()

	-- draw UI here
end

function MainGame:keypressed(key)
	-- love.errhand("co jest")
	-- setScreen('menu')
end

return MainGame