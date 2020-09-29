local c = {}

c.debug = true

c.windowWidth = 1024
c.windowHeight = 576
c.fullscreen = false

c.musicOn = false --TODO make it work
c.soundOn = false --TODO ^

c.map = require("src/config/mapConfig")
c.camera = require("src/config/camera")
-- c.nations = require("src/config/nations")
-- c.requests = require("src/config/requests")
c.textures = require("src/config/textures")
-- -- c.buildings is added in MainGame:load
-- c.items = require("src/config/items")
-- c.units = require("src/config/units")

c.debug = c.debug and require("src/config/debug") or {}

-- if c.debug.override then
--     c.debug.override(c)
-- end

-- here temporarily
c.maxEntityHeight = 2

return c