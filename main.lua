Object = require ("deps/classic")
tick = require ("deps/tick")
fileTool = require("deps/fileFun")
ut = require("deps/utility")
config = require("src/config/config")

stdFontPath = "fonts/verdana.ttf"
stdFont = love.graphics.newFont(stdFontPath, 24)

local screenManager = require("deps/screenManager")
setScreen = screenManager.setScreen

screenManager.addScreen(require("src/mainMenuScreen"), "menu")
screenManager.addScreen(require("src/gameScreen"), "game", true)

function love.load()
	-- local MenuManager = require("deps/menu")
	-- MenuManager.addTextures(config.idTextures)
end

function love.update(dt)
	tick.update(dt)
	screenManager.update(dt)
end

function love.draw()
	screenManager.draw()
end

function love.keypressed(key)
	if key == "f11" then
		--fullscreen
		if config.fullscreen == true then
			love.window.setFullscreen(false)
			config.fullscreen = false
		else
			love.window.setFullscreen(true)
			config.fullscreen = true
		end
	elseif key == "f12" then
		print("doing f12")
		dofile("./citizens/command.lua")
	end
	screenManager.keypressed(key)
end

function love.keyreleased(key)
	screenManager.keyreleased(key)
end

function love.mousemoved(x, y, dx, dy)
	screenManager.mousemoved(x, y, dx, dy)
end

function love.mousepressed(x, y, button)
	screenManager.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
	screenManager.mousereleased(x, y, button)
end

function love.wheelmoved(x, y)
	screenManager.wheelmoved(x, y)
end

function love.touchpressed(id, x, y)
	screenManager.touchpressed(id, x, y)
end

function love.touchreleased(id, x, y)
	screenManager.touchreleased(id, x, y)
end