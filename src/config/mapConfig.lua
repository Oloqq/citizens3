local m = {}

local gr = love.graphics

m.tileSize = 32

m.tiles = {
	grass = {
		typeStr = "grass",
		build = true,
		img = gr.newImage("img/grass.png")
	},
	water = {
		typeStr = "water",
		build = false,
		img = gr.newImage("img/water.png")
	}
}

--number codes for smaller files and easier loading
local mt = m.tiles
mt[1] = mt.grass
mt[2] = mt.water

return m