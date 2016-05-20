local Kinetic = require 'kinetic'
local Static = require 'static'
local Background = require 'background'
local Monster = require 'monster'
local Player = require 'player'

function love.load(arg)
	background = Background:new()
	player = Player:new()
	--monster = Monster:new()
end

function love.keypressed(key, scancode, isrepeat)
	if key == 'escape' then
		love.event.quit()
	elseif key == 'up' or key == 'e' then
		player:setAction('walk')
		player.dir = 'up'
	elseif key == 'down' or key == 'd' then
		player:setAction('walk')
		player.dir = 'down'
	elseif key == 'right' or key == 'f' then
		player:setAction('walk')
		player.dir = 'right'
	elseif key == 'left' or key == 's' then
		player:setAction('walk')
		player.dir = 'left'
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
	for e1 in pairs(Kinetic.instances) do
		e1:update(dt)
		for e2 in pairs(Kinetic.instances) do
			if e1 ~= e2 and e1:intersects(e2) then
				e1:collide(dt, e2)
			end
		end

		for _, e2 in ipairs(Static:nearby(e1)) do
			if e1:intersects(e2) and e2.solid then
				e1:setAction('push', e2)
			end
		end
	end
end


function love.draw()
	love.graphics.scale(4, 4)

	-- Add generator for iterating over statics
	for xy, tab in pairs(Static.instances) do
		for _, e in ipairs(tab) do
			e:draw()
		end
	end

	for e in pairs(Kinetic.instances) do
		e:draw()
	end
end
