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

	if player:collides(monster, 5) then
		player:setAction('bump')
	end

	if love.keyboard.isDown('q') then
		love.event.push('quit')
	end

end


function love.draw(dt)
	love.graphics.scale(4, 4)
	background:draw()
	monster:draw()
	player:draw()
end
