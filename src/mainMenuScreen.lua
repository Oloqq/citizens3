local MainMenu = Screen:extend()

local config = config
local love = love
local gr = love.graphics

function MainMenu:load(args)
	print('main menu loaded')
end

function MainMenu:resume()
	print('menu resumed')
end

function MainMenu:update(dt)
	
end

function MainMenu:draw()
	
end

function MainMenu:keypressed(key)
	setScreen('game')
end

return MainMenu