local GameScreen = Screen:extend()

local config = config
local love = love
local gr = love.graphics
local kb = love.keyboard

local Camera = require("deps/camera")
local Selection = require("deps/selection")
local Renderer = require("src/renderer")

function GameScreen:load(args)
	if not args then error('no args') end
	self.game = args.game or error("args.game = nil")

	self.camera = Camera()
	self.renderer = Renderer(self.camera, self.game)
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
	-- self.camera:set()
	-- self.game:draw(self.camera:getBounds(), self.unit)
	-- self.unit:draw()
	-- self.camera:unset()
	self.renderer:draw()

	-- local canvas = self.game.map.tileCanvas
	-- local quad = gr.newQuad(self.camera.translation.x, self.camera.translation.y, 200, 200, canvas:getWidth(), canvas:getHeight())
	-- gr.draw(canvas, quad, 0, 0)

	-- UI
	self.selection:draw()
end

function GameScreen:keypressed(key)
	-- setScreen('menu')
end

function GameScreen:mousepressed(x, y, b)
	-- local tilex, tiley = self.game.map:worldToTile(self.camera:screenToWorld(x, y))
	if b == 1 then
		self.selection:start(x, y)
	end
end

function GameScreen:mousereleased(x, y, b)
	if b == 1 then
		local sx, sy, ex, ey = self.selection:finish()
		sx, sy = self.camera:screenToWorld(sx, sy)
		ex, ey = self.camera:screenToWorld(ex, ey)
		self.selected = self.game:select(sx, sy, ex, ey)
	end
end

function GameScreen:mousemoved(x, y)
	self.selection:update(x, y)
end

return GameScreen