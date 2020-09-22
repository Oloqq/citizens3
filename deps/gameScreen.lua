--[[
Olo 2017
v2.0
Library for LOVE for handling game screens
Make sure Object is required from the classic library
main.lua template at the bottom
]]

GameScreen = Object:extend()

function GameScreen:new()
	--
end

function GameScreen:update(dt)
	--
end

function GameScreen:draw()
	--
end

function GameScreen:keypressed(key)
	--
end

function GameScreen:keyreleased(key)
	--
end

function GameScreen:mousemoved(x, y, dx, dy)
	--
end

function GameScreen:mousepressed(x, y, button)
	--
end

function GameScreen:mousereleased(x, y, button)
	--
end

function GameScreen:wheelmoved(x, y)
	--
end

function GameScreen:touchpressed(id, x, y)
	self:mousepressed(x, y, 1)
end

function GameScreen:touchreleased(id, x, y)
	self:mousereleased(x, y, 1)
end

function GameScreen:gamepadpressed(joystick, button)
	--
end

function GameScreen:gamepadreleased(joystick, button)
	--
end

function GameScreen:load(args)
	--
end

function GameScreen:resume(args)
	--
end

function GameScreen:pause(args)
	return nil
end

function GameScreen:exit(args)
	return nil
end

---------------------------------------------------------------------------------

local GameScreenMng = {}

GameScreenMng.screens = {}
GameScreenMng.loaded = {}
GameScreenMng.curr = nil

-- {...} will be passsed to load function
function GameScreenMng.setScreen(id, loadArgs, exitArgs, pause)
	local ret = nil
	pause = pause or false

	if GameScreenMng.curr ~= nil then
		if pause then
			ret = GameScreenMng.screens[GameScreenMng.curr]:pause(exitArgs)
		else
			ret = GameScreenMng.screens[GameScreenMng.curr]:exit(exitArgs)
		end
	end

	GameScreenMng.curr = id

	if not GameScreenMng.loaded[GameScreenMng.curr] then
		GameScreenMng.screens[GameScreenMng.curr]:load(loadArgs)
		GameScreenMng.loaded[id] = true
	else
		GameScreenMng.screens[GameScreenMng.curr]:resume(loadArgs)
	end

	return ret
end

function GameScreenMng.addScreen(screen, id, set)
	GameScreenMng.screens[id] = screen
	GameScreenMng.loaded[id] = false

	if set == true then
		GameScreenMng.setScreen(id)
	end
end

function GameScreenMng.resetScreen(id)
	GameScreenMng.loaded[id] = false
end

function GameScreenMng.update(dt)
	GameScreenMng.screens[GameScreenMng.curr]:update(dt)
end

function GameScreenMng.draw()
	GameScreenMng.screens[GameScreenMng.curr]:draw(dt)
end

function GameScreenMng.keypressed(key)
	GameScreenMng.screens[GameScreenMng.curr]:keypressed(key)
end

function GameScreenMng.keyreleased(key)
	GameScreenMng.screens[GameScreenMng.curr]:keyreleased(key)
end

function GameScreenMng.mousemoved(x, y, dx, dy)
	GameScreenMng.screens[GameScreenMng.curr]:mousemoved(x, y)
end

function GameScreenMng.mousepressed(x, y, button)
	GameScreenMng.screens[GameScreenMng.curr]:mousepressed(x, y, button)
end

function GameScreenMng.mousereleased(x, y, button)
	GameScreenMng.screens[GameScreenMng.curr]:mousereleased(x, y, button)
end

function GameScreenMng.wheelmoved(x, y)
	GameScreenMng.screens[GameScreenMng.curr]:wheelmoved(x, y)
end

function GameScreenMng.touchpressed(id, x, y)
	GameScreenMng.screens[GameScreenMng.curr]:touchpressed(id, x, y)
end

function GameScreenMng.touchreleased(id, x, y)
	GameScreenMng.screens[GameScreenMng.curr]:touchreleased(id, x, y)
end

function GameScreenMng.gamepadpressed(joystick, button)
	GameScreenMng.screens[GameScreenMng.curr]:gamepadpressed(joystick, button)
end

function GameScreenMng.gamepadreleased(joystick, button)
	GameScreenMng.screens[GameScreenMng.curr]:gamepadreleased(joystick, button)
end



return GameScreenMng

--[[ exemplary main.lua, remember to get rid of unnecessary functions
Object = require "deps/classic" 
tick = require "deps/tick"

--this will also include GameScreen globally
local screenManager = require "deps/gameScreen"

function love.load()
	--global handle for changing game screen
	setScreen = screenManager.setScreen

	screenManager.addScreen(require("src/screen/mainMenu"), "menu", true)
	screenManager.addScreen(require("src/screen/mainGame"), "game") 
end

function love.update(dt)
	tick.update(dt)
	screenManager.update(dt)
end

function love.draw()
	screenManager.draw()
end

function love.keypressed(key)
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

function love.touchpressed(id, x, y)
	screenManager.touchpressed(id, x, y)
end

function love.touchreleased(id, x, y)
	screenManager.touchreleased(id, x, y)
end

function love.gamepadpressed(joystick, button)
	screenManager.gamepadpressed(joystick, button)
end

function love.gamepadreleased(joystick, button)
	screenManager.gamepadreleased(joystick, button)
end

]]