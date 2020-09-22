--[[
Olo 2017-2018
v2.0
Library for LOVE for easy animation handling with a spritesheet

Requires "classic"
]]

local Animation = Object:extend()

--only path is mandatory
function Animation:new(data)
	local framesx = data.framesx or 1
	local framesy = data.framesy or 1
	self.frameMax = data.frameMax or framesx * framesy
	self.frameMin = data.frameMin or 1
	self.current = self.frameMin
	
	self.image = love.graphics.newImage(data.path)
	self.fps = data.fps or 0
	
	self.frameList = {}

	local imgWidth = self.image:getWidth()
	local imgHeight = self.image:getHeight()

	self.frameWidth = data.frameWidth or imgWidth
	self.frameHeight = data.frameHeight or imgHeight
	
	for y = 0, framesy - 1 do
        for x = 0, framesx - 1 do
            table.insert(self.frameList, love.graphics.newQuad(
				x * self.frameWidth, y * self.frameHeight, self.frameWidth,
				self.frameHeight, imgWidth, imgHeight))
			
			if #self.frameList == self.frameMax then break end
        end
    end
end

function Animation:update(dt)
	self.current = self.current + self.fps * dt
	if self.current >= self.frameMax + 1 then
		self.current = self.frameMin
	end
end

function Animation:draw(x, y, w, h, r)
	love.graphics.draw(self.image, self.frameList[math.floor(self.current)],
	x, y, r, w / self.frameWidth, h / self.frameHeight,
	self.frameWidth / 2, self.frameHeight / 2)
end

function Animation:reset()
	self.current = self.frameMin
end

return Animation

--[[
	data {
		path
		fps
		frameWidth
		frameHeight
		frameMin
		frameMax
	}
]]