--[[
Olo 2017
v1.0
Library for LOVE for menus
Create menus using the manager (further in the file)
Paste correct path to the classic library
]]

Object = require "deps/classic"

MenuElement = Object:extend()

local textures

function MenuElement.setTextureReference(ref)
	textures = ref
end

function MenuElement.getTextureReference()
	return textures
end

function MenuElement:new(x, y, width, height, textureIndex, caption)
	self.x = x
	self.y = y
	self.width = width
	self.height = height
	self.baseTexture = textureIndex
	self.secondaryTexture = "buttonClick"
	self.textureIndex = textureIndex
	self.caption = caption
	self.textScale = 1
	--if equal to 0 this won't bounce (checkbox)
	self.bounceSpeed = 10
	self.down = false

end

function MenuElement:draw(r, g, b)
	love.graphics.draw(textures[self.textureIndex], self.x, self.y, 0, self.width / textures[self.textureIndex]:getWidth(),
						self.height / textures[self.textureIndex]:getHeight())
	--set color for font
	love.graphics.setColor(r, g, b)

	if self.caption ~= nil then
		local factor = 0
		if self.bounceSpeed == 0 then
			--it is a checkbox, move text slightly to the right
			factor = 32
		end

		love.graphics.print(self.caption, self.x + factor + self.width / 2,
		 	self.y + self.height / 2 - (love.graphics.getFont():getHeight() * self.textScale) / 2,
		 	0, self.textScale, self.textScale, love.graphics.getFont():getWidth(self.caption) / 2)
	end
	--reset color
	love.graphics.setColor(255, 255, 255)
end

function MenuElement:transform(newType, index, clickedIndex, caption, textScale)
	if newType == "checkbox" then
		self.bounceSpeed = 0
		self.down = false

	elseif newType == "button" then
		self.bounceSpeed = 10
		self.down = false
	end

	if index ~= nil then
		self:setTexture(index, clickedIndex)
	end

	if caption ~= nil then
		self.caption = caption
	end

	if textScale ~= nil then
		self.textScale = textScale
	end
end

function MenuElement:setTexture(index, clickedIndex)
	self.baseTexture = index
	self.textureIndex = index

	if clickedIndex ~= nil then
		self.secondaryTexture = clickedIndex
	end
end

function MenuElement:setCaption(newCaption)
	self.caption = newCaption
end

-------------------------------------------------

Button = MenuElement:extend()

function Button:new(x, y, width, height, textureIndex, caption)
	MenuElement.new(self, x, y, width, height, textureIndex, caption)
	self.bounceBackTime = 1
	self.bbTimeLeft = 0
end

function Button:update(dt)
	if self.bbTimeLeft > 0 then
		self.bbTimeLeft = self.bbTimeLeft - dt * self.bounceSpeed
	else
		self.textureIndex = self.baseTexture
		self.down = false
	end
end

function Button:onClick()
	self.bbTimeLeft = self.bounceBackTime
	if self.down == true then
		self.down = false
		self.textureIndex = self.baseTexture
	else
		self.down = true
		self.textureIndex = self.secondaryTexture
	end
end

function Button:draw(r, g, b)
	MenuElement.draw(self, r, g, b)
end