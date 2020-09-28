local s = Object:extend()
local love = love

local width = 4

function s:new()
	self.on = false
	self.startx = 0
	self.starty = 0
	self.endx = 0
	self.endy = 0
end

function s:start(x, y)
	self.startx = x or error()
	self.starty = y or error()
	self.endx = x
	self.endy = y
	self.on = true
end

function s:finish()
	self.on = false
	return self.startx, self.starty, self.endx, self.endy
end

function s:update(x, y)
	if not self.on then return end
	self.endx = x or error()
	self.endy = y or error()
end

function s:draw()    
	if not self.on then return end
	love.graphics.setLineWidth(width)
	love.graphics.rectangle('line', self.startx, self.starty, self.endx - self.startx, self.endy - self.starty)
end

return s