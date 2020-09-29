local u = Object:extend()

local love = love
local gr = love.graphics
local config = config

function u:new(x, y)
	self.x = x * config.map.tileSize + config.map.tileSize / 2
	self.y = y * config.map.tileSize + config.map.tileSize / 2
	self.img = config.textures.unit
end

function u:update(dt)
	--
end

function u:draw()
	-- gr.rectangle("fill", self.x, self.y,  20, 20)
	gr.draw(self.img, self.x - self.img:getWidth()/2, self.y - self.img:getHeight())
end

return u