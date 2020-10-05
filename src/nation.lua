local n = Object:extend()

function n:new(game, id, culture)
	self.game = game
	self.id = id
	local data = require("data/nations/"..culture)
	self.buildings = data.buildings
end

return n