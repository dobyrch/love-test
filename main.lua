local Entity = require 'entity'
local Background = require 'background'
local Monster = require 'monster'
local Player = require 'player'

local tiles = {
	{1,2,2,2,2,2,2,2,2,3},
	{4,5,5,0,5,5,0,5,5,6},
	{4,5,5,5,5,5,5,5,5,6},
	{4,5,0,5,5,5,5,0,5,6},
	{4,5,5,5,5,5,5,5,5,6},
	{4,5,5,5,0,5,5,5,0,6},
	{4,5,0,5,5,5,5,5,5,6},
	{4,5,5,5,5,5,5,0,5,6},
	{7,8,8,8,8,8,8,8,8,9},
}



function love.load(arg)
	background = Background:new(tiles)
	player = Player:new()
	monster = Monster:new()
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
	background:update(dt)

	for e1 in pairs(Entity.instances) do
		e1:update(dt)
		for e2 in pairs(Entity.instances) do
			if e1 ~= e2 and e1:intersects(e2) then
				e1:collide(dt, e2)
			end
		end
	end
end


function love.draw(dt)
	love.graphics.scale(4, 4)

	background:draw()

	for e in pairs(Entity.instances) do
		e:draw()
	end
end
