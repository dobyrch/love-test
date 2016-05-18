Entity = require 'entity'
Background = require 'background'
Monster = require 'monster'
Player = require 'player'

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


function love.update(dt)
	background:update(dt)
	player:update(dt)
	monster:update(dt)
	if player.sword then
		player.sword:update(dt)
	end

	for _, e1 in pairs(Entity.instances) do
		for _, e2 in pairs(Entity.instances) do
			if e1 ~= e2 and e1:intersects(e2) then
				e1:collide(dt, e2)
			end
		end
	end
end


function love.draw(dt)
	love.graphics.scale(4, 4)
	background:draw()
	monster:draw()
	player:draw()
	if player.sword then
		player.sword:draw()
	end
end
