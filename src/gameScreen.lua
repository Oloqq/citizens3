local MainGame = Screen:extend()

local config = config
local love = love
local gr = love.graphics
local kb = love.keyboard

local Camera = require("deps/camera")
local Map = require("src/map/map")
local Unit = require("src/unit")

function MainGame:load(args)
	self.camera = Camera()
	self.map = Map('maps/maptest')
	-- print('main game loaded')

	self.unit = Unit(2, 2)
end

function MainGame:resume()
	print('game resumed')
end

function MainGame:update(dt)
	self.camera:update(dt)
	self.map:update(dt)
	self.unit:update(dt)
end

function MainGame:draw()
	self.camera:set()

	self.map:draw()
	self.unit:draw()

	self.camera:unset()

	-- draw UI here
end

function MainGame:keypressed(key)
	-- setScreen('menu')
end

function MainGame:mousemoved(x, y)
	--
end

return MainGame