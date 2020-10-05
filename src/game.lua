local g = Object:extend()
local Map = require("src/map/map")

local Unit = require("src/unit")
local Nation = require("src/nation")

function g:new()
	self.map = Map('data/maps/maptest')
	self.nations = {}
	for i=1, self.map.playersCount do
		self.nations[#self.nations+1] = Nation(self, i, 'asian')
	end
	
	self.buildings = {}

	--TEMP
	local x, y = self.map:tileToWorld(2, 2)
	self.unit = Unit(x, y)
	x, y = self.map:tileToWorld(2, 4)
	self.unit2 = Unit(x, y)
	self.unit2.test = function() end
end

function g:update(dt)
	self.map:update(dt)
	self.unit:update(dt)
	self.unit2:update(dt)
end

function g:place(nationid, x, y, name)
	print('placing '..name..' for '..nationid..' at '..x..' '..y)
	local nation = self.nations[nationid]
	if not nation then return 'nonexistant nation '..nationid end
	local building = nation.buildings[name]
	if not building then return 'nonexistent building'..name end

end

function g:select(sx, sy, ex, ey)
	local x, y = self.map:worldToTile(sx, sy)
	print(x, y)
	return "ŁODTEGO"
end

return g