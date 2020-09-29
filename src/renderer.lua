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

	-- Camera culling
	local margin = config.camera.margin
	gr.push()
	gr.translate(margin.left, margin.top)

	-- Draw tile canvas
	gr.draw(self.game.map.tileCanvas, self.canvasQuad, 0, 0)

	-- Outline the map viewport
	gr.setLineWidth(1)
	gr.rectangle('line', 0, 0, w, h)

	-- Draw other objects (temp)
	--[[
	local tlx, tly = self.camera:screenToWorld(margin.left, margin.top)
	local brx, bry = self.camera:screenToWorld(margin.left + w, margin.top + h)
	local corners = {
		topleft = {
			x, y = self.camera:screenToWorld(margin.left, margin.top)
		},
		botright = {
			x, y = self.camera:screenToWorld(margin.left + w, margin.top + h)
		}
	}
	]]

	local tlx, tly = self.camera:screenToWorld(margin.left, margin.top)
	local brx, bry = self.camera:screenToWorld(margin.left + w, margin.top + h)
	local corners = {
		topleft = {
			x = tlx,
			y = tly
		},
		botright = {
			x = brx,
			y = bry
		}
	}

	self.camera:set()
	if self.game.unti:isVisible(corners) then
		self.game.unit:draw()
	end
	self.camera:unset()

	gr.pop()
end

return r