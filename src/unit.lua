local u = Object:extend()

local love = love
local gr = love.graphics
local config = config

function u:new(x, y)
	self.x = x
	self.y = y
	self.img = config.textures.unit
end

function u:update(dt)
	self:test(dt)
end

function u:draw()
	-- gr.rectangle("fill", self.x, self.y,  20, 20)
	gr.draw(self.img, self.x - self.img:getWidth()/2, self.y - self.img:getHeight())
end

function u:test(dt)
	local speed = 200
	local kb = love.keyboard
	if kb.isDown('left') then
		self.x = self.x - dt * speed
	elseif kb.isDown('right') then
		self.x = self.x + dt * speed
	end

	if kb.isDown('up') then
		self.y = self.y - dt * speed
	elseif kb.isDown('down') then
		self.y = self.y + dt * speed
	end
end

return u