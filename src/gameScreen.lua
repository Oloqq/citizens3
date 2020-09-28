local GameScreen = Screen:extend()

local config = config
local love = love
local gr = love.graphics
local kb = love.keyboard

local Camera = require("deps/camera")
local Selection = require("deps/selection")

function GameScreen:load(args)
	if not args then error('no args') end
	self.game = args.game or error("args.game = nil")

	self.camera = Camera()
	self.selection = Selection()

	self.selected = nil
end

function GameScreen:resume()
	print('game resumed')
end

function GameScreen:update(dt)
	self.camera:update(dt)
	self.game:update(dt)
end

function GameScreen:draw()
	-- Game world
	self.camera:set()
	self.game:draw()
	self.camera:unset()

	-- UI
	self.selection:draw()
end

function GameScreen:keypressed(key)
	-- setScreen('menu')
end

function GameScreen:mousepressed(x, y, b)
	-- local tilex, tiley = self.game.map:worldToTile(self.camera:undo(x, y))
	if b == 1 then
		self.selection:start(x, y)
	end
end

function GameScreen:mousereleased(x, y, b)
	if b == 1 then
		local sx, sy, ex, ey = self.selection:finish()
		sx, sy = self.camera:undo(sx, sy)
		ex, ey = self.camera:undo(ex, ey)
		self.selected = self.game:select(sx, sy, ex, ey)
	end
end

function GameScreen:mousemoved(x, y)
	self.selection:update(x, y)
end

return GameScreen