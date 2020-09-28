local MapLoader = require("src/map/mapLoader")
local Map = MapLoader:extend()

local Tile = require("src/map/tile")

local gr = love.graphics
local kb = love.keyboard
local config = config

function Map:new(path)
    self.tileSize = config.map.tileSize

    if path then self:load(path) end
end

function Map:update(dt)
    --
end

function Map:draw()    
    gr.draw(self.tileCanvas)
    gr.draw(self.debugCanvas)
end

function Map:worldToTile(x, y)
    x, y = math.floor(x / self.tileSize), math.floor(y / self.tileSize)

    local inside = true
    if x < 1 or y < 1 or x > self.width or y > self.height then inside = false end 
    return x, y, inside
end

-- --return x, y as tiles and true if tile is inside the map
-- function Map:screenToTile(x, y)
--     local x, y = self.camera:undo(x, y)
--     x, y = math.floor(x / self.tileSize), math.floor(y / self.tileSize)

--     local b = true
--     if x < 1 or y < 1 or x > self.width or y > self.height then b = false end 
--     return x, y, b
-- end

return Map