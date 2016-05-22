local Background = require 'background'
local Entity = require 'entity'
local Kinetic = require 'kinetic'
local Monster = require 'monster'
local Player = require 'player'
local Scroller = require 'scroller'
local Static = require 'static'
require 'reactions'


function love.load(arg)
	background = Background:new()
	player = Player:new()
	monster = Monster:new()
end


function love.keypressed(key, scancode, isrepeat)
	if key == 'escape' then
		love.event.quit()
	elseif key == 'up' or key == 'e' then
		player:setAction('walk')
	elseif key == 'down' or key == 'd' then
		player:setAction('walk')
	elseif key == 'right' or key == 'f' then
		player:setAction('walk')
	elseif key == 'left' or key == 's' then
		player:setAction('walk')
	elseif key == 'space' or key == 'k' then
		player:setAction('swing')
	end
end


function love.keyreleased(key, scancode)
	if key == 'escape' then
		love.event.quit()
	elseif key == 'up' or key == 'e' then
		player:setAction('walk')
	elseif key == 'down' or key == 'd' then
		player:setAction('walk')
	elseif key == 'right' or key == 'f' then
		player:setAction('walk')
	elseif key == 'left' or key == 's' then
		player:setAction('walk')
	end
end


function love.update(dt)
	-- Scroll the screen if the player moves out of bounds
	if scroller and not scroller.done then
		scroller:update(dt)
		return
	end

	local outdir = player:outOfBounds()
	if outdir then
		scroller = Scroller:new(outdir)
	end

	-- Update position and animation of each entity
	for e in pairs(Kinetic.instances) do
		e:update(dt)
	end

	for e in Static:iterAll() do
		e:update(dt)
	end

	-- Resolve collisions between entities
	for e1 in pairs(Kinetic.instances) do
		for e2 in pairs(Kinetic.instances) do
			if e1:intersects(e2) then
				e1:collide(e2)
			end
		end

		for e2 in Static:iterNear(e1) do
			if e1:intersects(e2) then
				e1:collide(e2)
			end
		end
	end
end


function love.draw()
	-- TODO: Scale appropriately based on resolution
	love.graphics.scale(4, 4)

	for e in Static:iterAll() do
		e:draw()
	end

	for e in pairs(Kinetic.instances) do
		e:draw()
	end
end
