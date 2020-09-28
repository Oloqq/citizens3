local g = Object:extend()
local Map = require("src/map/map")

function g:new()
	self.map = Map('maps/maptest')
end

function g:update(dt)
	self.map:update(dt)
end

function g:draw()    
	self.map:draw()
end

function g:select(rx, ry, ex, ey)
	return "ŁODTEGO"
end

return g