require 'player'
require 'background'

scale = 4

tiles = {
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
	player = Player:new()
	background = Background:new(tiles)
end


function love.update(dt)
	background:update(dt)
	player:update(dt)

	if love.keyboard.isDown('q') then
		love.event.push('quit')
	end

end


function love.draw(dt)
	background:draw()
	player:draw()
end
