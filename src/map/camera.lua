local Camera = Object:extend()
local gr = love.graphics
local kb = love.keyboard
local config = config
local cc = config.camera

function Camera:new()
	self.translation = cc.initialTranslation
	self.scale = cc.initialScale
end

function Camera:update(dt)
	-- Mouse movement
	if cc.mouseMovement then
		local x, y = love.mouse.getPosition()
		if x < cc.mouseMovementMargin then
			self:move(-cc.speed * dt, nil)
		elseif x > config.windowWidth - cc.mouseMovementMargin then
			self:move(cc.speed * dt, nil)
		end

		if y < cc.mouseMovementMargin then
			self:move(nil, -cc.speed * dt)
		elseif y > config.windowHeight - cc.mouseMovementMargin then
			self:move(nil, cc.speed * dt)
		end
	end

	-- Keyboard movement
	if kb.isDown(cc.left) then
		self:move(-cc.speed * dt, nil)
	elseif kb.isDown(cc.right) then
		self:move(cc.speed * dt, nil)
	end

	if kb.isDown(cc.up) then
		self:move(nil, -cc.speed * dt)
	elseif kb.isDown(cc.down) then
		self:move(nil, cc.speed * dt)
	end

	-- Keyboard zoom
	if kb.isDown(cc.zoomin) then self:zoom(cc.keyboardScaleSpeed * dt) end
	if kb.isDown(cc.zoomout) then self:zoom(-cc.keyboardScaleSpeed * dt) end
end

function Camera:zoom(s)
	if self.scale + s < cc.minZoom or self.scale + s > cc.maxZoom then
		return
	end

	local movx = config.windowWidth / self.scale / (self.scale + s) / 2 * s
	local movy = config.windowHeight  / self.scale / (self.scale + s) / 2 * s

	self:move(movx, movy)

	self.scale = self.scale + s
end

function Camera:move(x, y)
	if x then self.translation.x = self.translation.x - x end
	if y then self.translation.y = self.translation.y - y end
end

-- function Camera:undo(x, y)
-- 	x = (x / self.scale - self.translation.x)
-- 	y = (y / self.scale - self.translation.y)
-- 	return x, y
-- end

function Camera:set()
	gr.push()
	-- rotation should go first
	gr.scale(self.scale)
	gr.translate(self.translation.x, self.translation.y)
end

function Camera:unset()
	gr.pop()
end

return Camera