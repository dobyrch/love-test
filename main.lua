require 'player'

scale = 4
up_step1 = nil
up_step2 = nil
right_stand = nil
right_step = nil
left_step = nil
left_stand = nil
down_step1 = nil
down_step2 = nil

background = {
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
	player:init(scale)

	grass = love.graphics.newImage('assets/grass.png')
	grass:setFilter('linear', 'nearest')
	grass_w, grass_h = grass:getWidth(), grass:getHeight()
	local quadinfo = {
		{0,  0}, {17,  0}, {34,  0},
		{0, 17}, {17, 17}, {34, 17},
		{0, 34}, {17, 34}, {34, 34},
	}
	grass_quads = {}
	for i, qi in ipairs(quadinfo) do
		grass_quads[i] = love.graphics.newQuad(qi[1], qi[2], 16, 16, grass_w, grass_h)
	end

	flowers = love.graphics.newImage('assets/flowers.png')
	flowers:setFilter('linear', 'nearest')
	flower_w, flower_h = flowers:getWidth(), flowers:getHeight()
	flower_quads = {}
	quadinfo = {
		{0, 0}, {17, 0}, {34, 0}, {51, 0},
	}
	for i, qi in ipairs(quadinfo) do
		flower_quads[i] = love.graphics.newQuad(qi[1], qi[2], 16, 16, flower_w, flower_h)
	end
end


dtotal = 0
fq = 1
function love.update(dt)
	dtotal = dtotal + dt
	if dtotal >= 0.25 then
		dtotal = dtotal - 0.25

		fq = fq%4 + 1
	end

	if love.keyboard.isDown('q') then
		love.event.push('quit')
	end

	_, _, width, height = player.quad:getViewport()
	dx, dy = 0, 0
	oldquad = player.quad
	if love.keyboard.isDown('down','d') and not love.keyboard.isDown('up','e') then
		if player.y < (love.graphics.getHeight() - height*scale) then
			dy = player.speed * dt
			if dtotal < 0.125 then
				player.quad = down_step1
			else
				player.quad = down_step2
			end
		end
	end
	if love.keyboard.isDown('up','e') and not love.keyboard.isDown('down','d') then
		if player.y > 0 then
			dy = -player.speed * dt
			if dtotal < 0.125 then
				player.quad = up_step1
			else
				player.quad = up_step2
			end
		end
	end
	if love.keyboard.isDown('left','s') and not love.keyboard.isDown('right','f') then
		if player.x > 0 then
			dx = -player.speed * dt
			if dtotal < 0.125 then
				player.quad = left_stand
			else
				player.quad = left_step
			end
		end
	end
	if love.keyboard.isDown('right','f') and not love.keyboard.isDown('left','s') then
		if player.x < (love.graphics.getWidth() - width*scale) then
			dx = player.speed * dt
			if dtotal < 0.125 then
				player.quad = right_stand
			else
				player.quad = right_step
			end
		end
	end

	if dx ~= 0 and dy ~= 0 then
		dx = dx / math.sqrt(2)
		dy = dy / math.sqrt(2)
	end

	player.x = player.x + dx
	player.y = player.y + dy
end


function love.draw(dt)
	for i, row in ipairs(background) do
		for j, num in ipairs(row) do
			local x, y = (j-1)*16*scale, (i-1)*16*scale
			if num == 0 then
				love.graphics.draw(flowers, flower_quads[fq], x, y, 0, scale, scale)
			else
				love.graphics.draw(grass, grass_quads[num], x, y, 0, scale, scale)
			end
		end
	end


	player:draw()
end
