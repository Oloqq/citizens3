local c = {}

c.debug = true

c.windowWidth = 1024
c.windowHeight = 576
c.fullscreen = false

c.musicOn = false --TODO make it work
c.soundOn = false --TODO ^

c.textures = require("src/config/textures")
c.map = require("src/config/mapConfig")
c.camera = require("src/config/camera")

c.debug = c.debug and require("src/config/debug") or {}

-- if c.debug.override then
--     c.debug.override(c)
-- end

-- here temporarily
c.maxEntityHeight = 2

return c