local MapLoader = Object:extend()
local Tile = require("src/map/tile")

local fileTool = require("deps/fileFun")
local config = config
local cm = config.map
local cd = config.debug

function MapLoader:load(folderPath)
	self:loadProperties(folderPath)

	--read file
	local lines = {}
	for line in love.filesystem.lines(folderPath.."/tiles.dat") do
		table.insert(lines, line)
	end

	self.tiles = {}
	
	--init tables
	for x=1, self.width do
		self.tiles[x] = {}
		for y=1, self.height do
			self.tiles[x][y] = 1
		end
	end

	--fill data
	for y=1, self.height do
		vals = fileTool.dottedVals(lines[y])
		for x=1, self.width do
			self.tiles[x][y] = Tile(vals[x])
		end
	end
	
	--create tileCanvas to display
	self:reloadCanvas()
	self:reloadDebugCanvas()
end

function MapLoader:loadProperties(folderPath)
	local lines = {}
	for line in love.filesystem.lines(folderPath.."/properties.dat") do
		table.insert(lines, line)
	end

	local readLine = 1
	self.name = fileTool.stringVal(lines[readLine]); readLine = readLine + 1
	self.description = fileTool.stringVal(lines[readLine]); readLine = readLine + 1
	self.width = fileTool.val(lines[readLine]); readLine = readLine + 1
	self.height = fileTool.val(lines[readLine]); readLine = readLine + 1
	self.playersCount = fileTool.val(lines[readLine]); readLine = readLine + 1
	
	-- self.width = self.width + 1
	-- self.height = self.height + 1
end

function MapLoader:reloadDebugCanvas()
	local gr = love.graphics
	self.debugCanvas = gr.newCanvas(self.tileSize * (self.width+1), 
	self.tileSize * (self.height+1))
	if not cd.debugView then return end
	gr.setCanvas(self.debugCanvas)

	if cd.tileBorders then
		--checker (tile borders)
		for x=1, self.width do
			gr.line(x*self.tileSize, self.tileSize,
				x*self.tileSize, (self.height+1)*self.tileSize)
		end
		for y=1, self.height do
			gr.line(self.tileSize, y*self.tileSize,
				(self.width+1)*self.tileSize, y*self.tileSize)
		end
	end

	--marked tiles
	gr.setColor(255, 0, 0)
	gr.setLineWidth(4)
	for i,v in ipairs(cd.debugMark) do
		gr.rectangle("line", v[1]*self.tileSize, v[2]*self.tileSize,
		 self.tileSize, self.tileSize)
	end
	gr.setLineWidth(1)
	gr.setColor(255, 255, 255)

	gr.setCanvas()
end

function MapLoader:reloadBuildingCanvas()
	local gr = love.graphics

	self.buildingCanvas = gr.newCanvas(self.tileSize * (self.width+1), 
	self.tileSize * (self.height+1))
	 gr.setCanvas(self.buildingCanvas)

	for x=1, self.width do
		for y=1, self.height do
			if self.tiles[x][y].structureImg then
				gr.draw(self.tiles[x][y].structureImg, x*self.tileSize, y*self.tileSize)
			end
		end
	end

	gr.setCanvas()
end

function MapLoader:reloadCanvas()
	local gr = love.graphics

	self.tileCanvas = gr.newCanvas(self.tileSize * (self.width+1), 
	 self.tileSize * (self.height+1))
	gr.setCanvas(self.tileCanvas)

	for x=1, self.width do
		for y=1, self.height do
			gr.draw(self.tiles[x][y].img, x*self.tileSize, y*self.tileSize)
		end
	end

	self:reloadBuildingCanvas()
end

return MapLoader