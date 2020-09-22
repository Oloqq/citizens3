--[[
Olo 2017-2018
v3.2
Library for LOVE for menus
Make sure Object is required from the classic library
TODO make love.graphic local
]]

local Button = Object:extend()
local textures = {}

local love = love

function Button:new(x, y, width, height, textureIndex, caption, func,
	 textureClickIndex, autofit, textCenter)
	self.x = x
	self.y = y
	self.width = width
	self.height = height
	self.autofit = autofit
	
	self.baseTexture = textureIndex
	self.secondaryTexture = textureClickIndex
	self.textureIndex = textureIndex
	self.pictureIndex = nil
	self.caption = caption
	self.textScale = 1
	self.textCenter = textCenter == nil and true or textCenter
	--if equal to 0 this won't bounce (checkbox)
	self.progressBar = false
	self.progress = 0
	self.bounceSpeed = 10
	self.down = false

	self.func = func or nil
	self.funcDelay = 0.15 --[s]

	self.bounceBackTime = 1
	self.bbTimeLeft = 0

	self.group = nil
end

function Button:update(dt)
	if self.bbTimeLeft > 0 then
		self.bbTimeLeft = self.bbTimeLeft - dt * self.bounceSpeed
	else
		self.textureIndex = self.baseTexture
		self.down = false
	end
end

function Button:draw(r, g, b)
	local w, h
	if self.autofit then
		w = self.width / textures[self.textureIndex]:getWidth()
		h = self.height / textures[self.textureIndex]:getHeight()
	else
		w = 1
		h = 1
	end

	if self.progressBar then
		love.graphics.draw(textures[self.baseTexture], self.x, self.y, 0, w, h)
		w = self.progress
		love.graphics.draw(textures[self.secondaryTexture], self.x, self.y, 0, w, h)
	else
		love.graphics.draw(textures[self.textureIndex], self.x, self.y, 0, w, h)
		if self.pictureIndex ~= nil then
			love.graphics.draw(textures[self.pictureIndex], self.x, self.y, 0, w, h)
		end
	end

	--set color for font
	love.graphics.setColor(r, g, b)

	if self.caption ~= nil then
		local factor = 0
		if self.bounceSpeed == 0 then
			--it is a checkbox, move text slightly to the right
			factor = 32
		end

		local x, y, o
		if self.textCenter then
			x = self.x + factor + self.width / 2
			y = self.y + self.height / 2 - (love.graphics.getFont():getHeight() * self.textScale) / 2
			o = love.graphics.getFont():getWidth(self.caption) / 2
		else
			x = self.x
			y = self.y
			o = 0
		end

		love.graphics.print(self.caption, x, y, 0, self.textScale,
			self.textScale, o)
	end
	--reset color
	love.graphics.setColor(255, 255, 255)
end

function Button:onClick(execute, indirect)
	indirect = indirect or false
	self.bbTimeLeft = self.bounceBackTime
	if self.down == true and (self.group == nil or indirect) then
		self.down = false
		self.textureIndex = self.baseTexture
	else
		self.down = true
		self.textureIndex = self.secondaryTexture
	end

	if execute and self.func then
		if self.funcDelay <= 0 then
			self.func()
		else
			tick.delay(self.func, self.funcDelay)
		end
	end
end

function Button:transform(newType, index, clickedIndex, pictureIndex, caption,
	 textScale, func, fd)
	if newType == "checkbox" then
		self.bounceSpeed = 0
		self.down = false
		self.group = nil

	elseif newType == "button" then
		self.bounceSpeed = 10
		self.down = false
		self.group = nil

	elseif newType == "progressBar" then
		self.bounceSpeed = 0
		self.down = false
		self.group = nil
		self.progressBar = true	

	elseif type(newType) == "table" then
		if newType[1] == "radio" then
			self.group = newType[2]
			self.bounceSpeed = 0
		end
	end

	self:setTexture(index, clickedIndex, pictureIndex)
	self:setCaption(caption, textScale, func, fd)
end

function Button:setTexture(index, clickedIndex, pictureIndex)
	if index then
		self.baseTexture = index
		self.textureIndex = index
	end
	if clickedIndex then self.secondaryTexture = clickedIndex end
	if pictureIndex ~= nil then self.pictureIndex = pictureIndex end
end

function Button:setCaption(newCaption, textScale, func, fd)
	if newCaption then self.caption = newCaption end
	if textScale then self.textScale = textScale end
	self:setFunc(func, fd)
end

--to reset function just pass an empty function
function Button:setFunc(func, fd)
	if func then self.func = func end
	if fd then self:setFuncDelay(fd) end
end

function Button:setFuncDelay(fd)
	self.funcDelay = fd
end

function Button:coordsToTable(table)
	table.x = self.x
	table.y = self.y
	table.width = self.width
	table.height = self.height
end

---------------------------------------------------------------------------

local Menu = Object:extend()

function Menu:new(x, y, width, height, margin, columns, rows, elementsMax,
	 title, imgIndex, newFont, newFontSize, fontColor, buttonDefaultTexture,
	 buttonClickDefaultTexture, autofit)
	elementsMax = elementsMax or 10000

	self.x = x
	self.y = y
	self.width = width
	self.height = height
	self.margin = margin
	self.title = title
	self.imgIndex = imgIndex

	self.elementAutofit = autofit or false

	self.buttonDefaultTexture = buttonDefaultTexture or "button"
	self.buttonClickDefaultTexture = buttonClickDefaultTexture or "buttonClick"

	if type(newFont) == "string" then
		self.font = love.graphics.newFont(newFont, newFontSize)
	else
		self.font = newFont
	end

	if fontColor and type(fontColor) == "table" then
		self.fontColor = fontColor
	else
		self.fontColor = {}
	end
	self.fontColor.r = self.fontColor.r or 0
	self.fontColor.g = self.fontColor.g or 0
	self.fontColor.b = self.fontColor.b or 0
	

	if self.title ~= nil then
		rows = rows + 1
	end
	if self.elementAutofit then
		self.elementHeight = (self.height - margin * (rows + 1)) / rows
		self.elementWidth = (self.width - margin * (columns + 1)) / columns
	else
		self.elementHeight = textures[self.buttonDefaultTexture]:getHeight()
		self.elementWidth = textures[self.buttonDefaultTexture]:getWidth()
	end
	if self.title ~= nil then
		self.y = self.y + self.elementHeight
		rows = rows - 1
	end

	self.margin = margin
	self.elements = {}
	local created = 0
	for i = 1, columns do
		self.elements[i] = {}
		for j = 1, rows do
			self.elements[i][j] = 
			 Button(self.x + self.margin + ((i - 1) * (self.elementWidth + margin)),
			  self.y + self.margin + ((j - 1) * (self.elementHeight + margin)),
			  self.elementWidth, self.elementHeight, self.buttonDefaultTexture,
			  "", nil, self.buttonClickDefaultTexture, self.elementAutofit)
			created = created + 1
			if created == elementsMax then
				break
			end
		end
		if created == elementsMax then
			break
		end
	end
	self.x = x
	self.y = y
end

--pass a table with button data, relative to the menu (without margin)
function Menu:addCustomButton(b)
	if not self.customButtons then
		self.customButtons = true
		self.elements[#self.elements + 1] = {}
	end
	
	self.elements[#self.elements][#self.elements[#self.elements] + 1]
	 = Button(self.x + b.x, self.y + b.y, b.width, b.height, b.defaultTexture,
	  b.caption, b.func, b.clickedTexture, b.autofit, b.textCenter)

	local e = self.elements[#self.elements][#self.elements[#self.elements]]
	if b.textScale then e.textScale = b.textScale end

	return self.elements[#self.elements][#self.elements[#self.elements]]
end

function Menu:setFontColor(r, g, b)
	self.fontColor.r = r
	self.fontColor.g = g
	self.fontColor.b = b
end

function Menu:onClick(x, y, b, execute)
	for i = 1, #self.elements do
		for j = 1, #self.elements[i] do
			e = self.elements[i][j]
			if x > e.x and x < e.x + e.width and y > e.y and y < e.y + e.height then
				e:onClick(execute)
				if e.group then
					for a = 1, #self.elements do
						for b = 1, #self.elements[a] do
							if self.elements[a][b].down and (a ~= i or b ~= j)
							and e.group == self.elements[a][b].group then
								self.elements[a][b]:onClick(false, true)
							end
						end
					end
				end
				return i, j
			end
		end
	end
end

function Menu:getSelectedRadio(group)
	local firstx, firsty
	for a = 1, #self.elements do
		for b = 1, #self.elements[a] do
			if self.elements[a][b].group == group then
				if not firstx then firstx = a; firsty = b; end
				if self.elements[a][b].down then
					return a, b
				end
			end
		end
	end
	--group does not exist or none of buttons is down
	--set the first encountered button as selected or throw an error
	if firstx then self.elements[firstx][firsty]:onClick()
	else love.errhand("Attempt to access a nonexistent radio group("..group..")") end
	return firstx, firsty
end

function Menu:update(dt)
	for i = 1, #self.elements do
		for j = 1, #self.elements[i] do
			self.elements[i][j]:update(dt)
		end
	end
end

function Menu:draw()
	love.graphics.draw(textures[self.imgIndex], self.x, self.y, 0, self.width / textures[self.imgIndex]:getWidth(),
						self.height / textures[self.imgIndex]:getHeight())

	local prevFont = love.graphics.getFont()
	love.graphics.setFont(self.font)

	if self.title ~= nil then
		love.graphics.setColor(self.fontColor.r, self.fontColor.g, self.fontColor.b)
		love.graphics.print(self.title, self.x + self.width / 2,
		 (self.y + self.margin) - self.font:getHeight() / 4, 0, 1, 1, self.font:getWidth(self.title) / 2)
		love.graphics.setColor(255, 255, 255)
	end

	for i, v in ipairs(self.elements) do
		for j, v in ipairs(self.elements[i]) do
			self.elements[i][j]:draw(self.fontColor.r, self.fontColor.g, self.fontColor.b)
		end
	end
	love.graphics.setFont(prevFont)
end

--------------------------------------------------------------------

local MenuManager = Object:extend()

function MenuManager:new()
	self.menus = {}
	self.curr = nil	
end

function MenuManager:update(dt, ...)
	if not self.menus[self.curr] then return end
	self.menus[self.curr]:update(dt)
	for i,v in pairs({...}) do
		self.menus[v]:update(dt)
	end
end

function MenuManager:draw(...)
	if not self.menus[self.curr] then return end
	self.menus[self.curr]:draw()
	for i,v in pairs({...}) do
		self.menus[v]:draw()
	end
end

function MenuManager:getMenu(index)
	-- if index == nil then
	-- 	return self.menus[self.curr]
	-- else
	-- 	return self.menus[index]
	-- end

	if index ~= nil then
		if self.menus[index] == nil then
			love.errhand("No menu of given index")
			return
		end
		return self.menus[index]
	end
	return self.menus[self.curr]
end

function MenuManager:addMenu(index, p)
	self.menus[index] = Menu(p.x, p.y, p.width, p.height, p.margin, p.columns,
	 p.rows, p.elementsMax, p.title, p.backgroundImageIndex, p.font, p.fontSize,
	 p.fontColor, p.buttonDefaultTexture, p.buttonClickDefaultTexture, p.autofit)
end

function MenuManager:switchMenu(index)
	if self.menus[index] ~= nil then
		--animations will reset
		self.curr = index
		self:update(100)
	end
	return self.menus[self.curr]
end

--returns index of clicked element
function MenuManager:onClick(x, y, b, ...)
	--return three values corresponding to the indexes and current menu
	q, w = self.menus[self.curr]:onClick(x, y, b, true)
	if q and w then return q, w, self.curr end
	for i,v in pairs({...}) do
		self.menus[v]:onClick(x, y, b, true)
		if q and w then return q, w, v end
	end
	return nil, nil, nil
end

function MenuManager.addTexture(index, value)
	if(type(value) == "string") then
		value = love.graphics.newImage(value)
	end
	textures[index] = value
end

function MenuManager.addTextures(tab)
	for k,v in pairs(tab) do
		textures[k] = love.graphics.newImage(v)
	end
end

function MenuManager.getTextureTable()
	return textures
end

function MenuManager.btn()
	return Button
end

return MenuManager

--[[
v1.1 functions can be assigned directly to buttons
v1.2 all code moved into single file
v1.3 MenuElement is just Button now
	 local require support
	 separate font for menus
v1.4 variable number of arguments in update() and draw(), can draw multiple menus
	 Button:coordsToTable()
v1.5 empty MenuManager no longer throws an error on update() and draw()
	 addMenu() takes table of additional keyword arguments (button default textures)

v2.0 MenuManager:addMenu() takes index and dictionary of properties	
	 MenuManager:addTextures() taking a key-value table
	 default button caption is just empty string

v3.0 Button.pictureIndex to display a picture on top of the button
	 added support for radio buttons
	 fixed a bug when func delay was = 0
	 MenuManager:switchMenu returns current menu
v3.1 added font color support in constructor, default is black not white
	 Menu:addButton
v3.2 made text centering optional (default is true for compatibility)
	 Menu:addCutomButton returns added button
]]