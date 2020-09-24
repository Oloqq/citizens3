local c = {}

c.debug = true

c.windowWidth = 1024
c.windowHeight = 576
c.fullscreen = false

c.musicOn = false --TODO make it work
c.soundOn = false --TODO ^

-- c.cameraSpeed = 600
-- c.scaleSpeed = 0.25
-- c.keyboardScaleSpeed = 10
-- c.minZoom = 0.1
-- c.maxZoom = 3
-- c.initialCameraTranslation = {x=0, y=0}
-- c.initialCameraScale = 1

-- c.cameraMargin = 10 --[[area where the cursor moves the camera, only works
--                         when mouseMapMovement is true]]
-- c.mouseMapMovement = false

c.map = require("src/config/mapConfig")
-- c.nations = require("src/config/nations")
-- c.requests = require("src/config/requests")
-- c.idTextures = require("src/config/textures")
-- -- c.buildings is added in MainGame:load
-- c.items = require("src/config/items")
-- c.units = require("src/config/units")
-- c.debug = c.debug and require("src/config/debug") or {}

-- if c.debug.override then
--     c.debug.override(c)
-- end


return c