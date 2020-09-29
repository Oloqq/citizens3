local r = Object:extend()
local love = love
local gr = love.graphics
local config = config

function r:new(camera, game)
	self.camera = camera
	self.game = game
	local pos = camera.translation
	local canvas = game.map.tileCanvas
	self.canvasQuad = gr.newQuad(pos.x, pos.y, gr.getWidth(), gr.getHeight(), 
			canvas:getWidth(), canvas:getHeight())
end

function r:add()

end

function r:draw()
	-- Update the quad with camera
	local x, y, w, h = unpack(self.camera:getQuad())
	self.canvasQuad:setViewport(x, y, w, h)

	-- Draw tile canvas
	local margin = config.camera.margin
	gr.draw(self.game.map.tileCanvas, self.canvasQuad, margin.left, margin.top)

	-- Outline the map viewport
	gr.rectangle('line', margin.left, margin.top, w, h)

	-- Draw other objects (temp)
	local tlx, tly = self.camera:screenToWorld(margin.left, margin.top)
	local brx, bry = self.camera:screenToWorld(margin.left + w, margin.top + h)

	self.camera:set()
	print(self.game.unit.x, tlx)
	if self.game.unit.x > tlx then
		self.game.unit:draw()
	end
	self.camera:unset()
end

return r