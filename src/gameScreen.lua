local GameScreen = Screen:extend()

local config = config
local love = love
local gr = love.graphics
local kb = love.keyboard

local Camera = require("deps/camera")
local Selection = require("deps/selection")
local Renderer = require("src/renderer")

function GameScreen:emit(msg, ...)
	if self.game[msg] and type(self.game[msg]) == 'function' then
		local response = self.game[msg](self.game, self.nationid, unpack({...}))
		if response then
			print(response)
		end
	else
		error('Invalid message to emit: '..msg)
	end
end

function GameScreen:load(args)
	if not args then error('no args') end
	self.nationid = 1 -- TEMP const
	self.game = args.game or error("args.game = nil")
	self.nation = self.game.nations[self.nationid]
	if not self.nation then error('Failed getting nation from game') end

	self.camera = Camera()
	self.renderer = Renderer(self.camera, self.game)
	self.selection = Selection()
	self.state = 'placing'

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
	self.renderer:draw()

	-- UI
	self.selection:draw()
end

function GameScreen:keypressed(key)
	-- if key == 's' then
	-- 	self.state = 'placing'
	-- end
end

function GameScreen:mousepressed(x, y, b)
	local tilex, tiley = self.game.map:worldToTile(self.camera:screenToWorld(x, y))
	if b == 1 then
		if self.state == 'selecting' then 
			self.selection:start(x, y) 
		elseif self.state == 'placing' then
			-- print('testPlacing at', tilex, tiley)
			-- self.game:testPlace(self.nationid, tilex, tiley, 'tower')
			self:emit('place', tilex, tiley, 'tower')
			-- self.nation:testPlace('tower', tilex, tiley)
		end
	end
end

function GameScreen:mousereleased(x, y, b)
	if b == 1 then
		if self.state == 'selecting' then
			local sx, sy, ex, ey = self.selection:finish()
			sx, sy = self.camera:screenToWorld(sx, sy)
			ex, ey = self.camera:screenToWorld(ex, ey)
			self.selected = self.game:select(sx, sy, ex, ey)
		end
	elseif b == 2 then
		-- if self.state == 'placing' then
		-- 	self.state = 'selecting'
		-- end
	end
end

function GameScreen:mousemoved(x, y)
	self.selection:update(x, y)
end

return GameScreen