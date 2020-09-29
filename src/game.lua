local g = Object:extend()
local Map = require("src/map/map")

local Unit = require("src/unit")

function g:new()
	self.map = Map('maps/maptest')
	local x, y = self.map:tileToWorld(2, 2)
	self.unit = Unit(x, y)
end

function g:update(dt)
	self.map:update(dt)
	self.unit:update(dt)
end

function g:select(sx, sy, ex, ey)
	local x, y = self.map:worldToTile(sx, sy)
	print(x, y)
	return "ŁODTEGO"
end

return g