--[[
Olo 2017
v3.0
Library for LOVE for handling game screens
Make sure Object is required from the classic library
main.lua template at the bottom
]]

Screen = Object:extend()
local Screen = Screen

function Screen:new()
	--
end

function Screen:update(dt)
	--
end

function Screen:draw()
	--
end

function Screen:keypressed(key)
	--
end

function Screen:keyreleased(key)
	--
end

function Screen:mousemoved(x, y, dx, dy)
	--
end

function Screen:mousepressed(x, y, button)
	--
end

function Screen:mousereleased(x, y, button)
	--
end

function Screen:wheelmoved(x, y)
	--
end

function Screen:touchpressed(id, x, y)
	self:mousepressed(x, y, 1)
end

function Screen:touchreleased(id, x, y)
	self:mousereleased(x, y, 1)
end

function Screen:gamepadpressed(joystick, button)
	--
end

function Screen:gamepadreleased(joystick, button)
	--
end

function Screen:load(args)
	--
end

function Screen:resume(args)
	--
end

function Screen:pause(args)
	return nil
end

function Screen:exit(args)
	return nil
end

---------------------------------------------------------------------------------

local ScreenManager = {}

ScreenManager.screens = {}
ScreenManager.loaded = {}
ScreenManager.curr = nil

-- {...} will be passsed to load function
function ScreenManager.setScreen(id, loadArgs, exitArgs, pause)
	local ret = nil
	pause = pause or false

	if ScreenManager.curr ~= nil then
		if pause then
			ret = ScreenManager.screens[ScreenManager.curr]:pause(exitArgs)
		else
			ret = ScreenManager.screens[ScreenManager.curr]:exit(exitArgs)
		end
	end

	ScreenManager.curr = id

	if not ScreenManager.loaded[ScreenManager.curr] then
		ScreenManager.screens[ScreenManager.curr]:load(loadArgs)
		ScreenManager.loaded[id] = true
	else
		ScreenManager.screens[ScreenManager.curr]:resume(loadArgs)
	end

	return ret
end

function ScreenManager.addScreen(screen, id, set)
	ScreenManager.screens[id] = screen
	ScreenManager.loaded[id] = false

	if set == true then
		ScreenManager.setScreen(id)
	end
end

function ScreenManager.resetScreen(id)
	ScreenManager.loaded[id] = false
end

function ScreenManager.update(dt)
	ScreenManager.screens[ScreenManager.curr]:update(dt)
end

function ScreenManager.draw()
	ScreenManager.screens[ScreenManager.curr]:draw(dt)
end

function ScreenManager.keypressed(key)
	ScreenManager.screens[ScreenManager.curr]:keypressed(key)
end

function ScreenManager.keyreleased(key)
	ScreenManager.screens[ScreenManager.curr]:keyreleased(key)
end

function ScreenManager.mousemoved(x, y, dx, dy)
	ScreenManager.screens[ScreenManager.curr]:mousemoved(x, y)
end

function ScreenManager.mousepressed(x, y, button)
	ScreenManager.screens[ScreenManager.curr]:mousepressed(x, y, button)
end

function ScreenManager.mousereleased(x, y, button)
	ScreenManager.screens[ScreenManager.curr]:mousereleased(x, y, button)
end

function ScreenManager.wheelmoved(x, y)
	ScreenManager.screens[ScreenManager.curr]:wheelmoved(x, y)
end

function ScreenManager.touchpressed(id, x, y)
	ScreenManager.screens[ScreenManager.curr]:touchpressed(id, x, y)
end

function ScreenManager.touchreleased(id, x, y)
	ScreenManager.screens[ScreenManager.curr]:touchreleased(id, x, y)
end

function ScreenManager.gamepadpressed(joystick, button)
	ScreenManager.screens[ScreenManager.curr]:gamepadpressed(joystick, button)
end

function ScreenManager.gamepadreleased(joystick, button)
	ScreenManager.screens[ScreenManager.curr]:gamepadreleased(joystick, button)
end

return ScreenManager

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