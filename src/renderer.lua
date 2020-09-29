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

	self.layers = {}
	self.toptile = 1
end

function r:queue(entity, b)
	local id = math.floor(entity.y / 32) - (self.toptile - 1)
 	local layer = self.layers[id]
 	layer[#layer+1] = entity

	if b then
		print(id)
	end
--  print(type(layer), #layer, #self.layers[math.floor(entity.y / 32) - (self.toptile - 1)])
end

function r:draw()
	-- Prepare for camera culling
	-- Update the quad with camera, determine visible part of the world,
	local x, y, w, h = unpack(self.camera:getQuad())
	self.canvasQuad:setViewport(x, y, w, h)
	local margin = config.camera.margin
	local left, top = self.camera:screenToWorld(margin.left, margin.top)
	local right, bottom = self.camera:screenToWorld(margin.left + w, margin.top + h)
	local borderBox = {
		left = left,
		top = top,
		right = right,
		bottom = bottom
	}
	-- Prepare layering of entities
	self.layers = {}
	local tileRows = nil
	tileRows, self.toptile = self.game.map:worldToTile(0, top)
	tileRows = math.ceil(h / config.map.tileSize) + config.maxEntityHeight
	for i=1, tileRows do
		self.layers[i] = {}
	end

	-- Prepare drawing
	gr.push()
	gr.translate(margin.left, margin.top)

	-- Draw desired part of the tile canvas
	gr.draw(self.game.map.tileCanvas, self.canvasQuad, 0, 0)

	-- Outline the map viewport (debug)
	gr.setLineWidth(1)
	gr.rectangle('line', 0, 0, w, h)

	-- Queue building and units for drawing
	if self.game.unit:isVisible(borderBox) then
		-- self.game.unit:draw()
		self:queue(self.game.unit, true)
		-- print('q1')
	end
	if self.game.unit2:isVisible(borderBox) then
		-- self.game.unit2:draw()
		self:queue(self.game.unit2)
		-- print('q2')
	end
	
	-- Draw entities in the correct order
	self.camera:set()
	for y,layer in ipairs(self.layers) do
		-- print('layer', y)
		for i,v in ipairs(layer) do
			v:draw()
			-- print('d')
		end
	end
	self.camera:unset()

	gr.pop()
end

return r