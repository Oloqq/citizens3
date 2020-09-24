local config = config

local Tile = Object:extend()

function Tile:new(code)
    self.code = code or love.errhand("Tile code = nil")
    t = config.map.tiles[code] or love.errhand("Tile code '"..(code or "nil").."' has no template")

    for k,v in pairs(t) do
        self[k] = v
    end

    self.structureImg = nil
    self.reference = {id = 0} --reference to structure at that tile
end

return Tile