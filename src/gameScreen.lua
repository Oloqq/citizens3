local MainGame = Screen:extend()

local config = config
local love = love
local gr = love.graphics

local Camera = require("src/map/camera")
local Map = require("src/map/map")

function MainGame:load(args)
	self.camera = Camera()
	self.map = Map()
	self.map:load('maps/maptest')
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
end

function MainGame:keypressed(key)
	-- setScreen('menu')
end

return MainGame