scale = 4
player = { x = 70*scale, y = 70*scale, speed = 40*scale, img = nil, quad = nil}
up_step1 = nil
up_step2 = nil
right_stand = nil
right_step = nil
left_step = nil
left_stand = nil
down_step1 = nil
down_step2 = nil

function love.load(arg)
	player.img = love.graphics.newImage('assets/link.png')
	player.img:setFilter("linear", "nearest")
	up_step1 = love.graphics.newQuad(0, 0, 12, 16, player.img:getDimensions())
	up_step2 = love.graphics.newQuad(14, 0, 12, 16, player.img:getDimensions())
	right_stand = love.graphics.newQuad(28, 0, 14, 16, player.img:getDimensions())
	right_step = love.graphics.newQuad(44, 0, 13, 16, player.img:getDimensions())
	left_step = love.graphics.newQuad(59, 0, 13, 16, player.img:getDimensions())
	left_stand = love.graphics.newQuad(74, 0, 14, 16, player.img:getDimensions())
	down_step1 = love.graphics.newQuad(90, 0, 12, 16, player.img:getDimensions())
	down_step2 = love.graphics.newQuad(104, 0, 12, 16, player.img:getDimensions())
	player.quad = down_step1
end


dtotal = 0
function love.update(dt)
	dtotal = dtotal + dt
	if dtotal >= 0.5 then
		dtotal = dtotal - 0.5
	end

	if love.keyboard.isDown('q') then
		love.event.push('quit')
	end

	x, y, width, height = player.quad:getViewport()
	if love.keyboard.isDown('left','s') then
		if player.x > 0 then
			player.x = player.x - (player.speed*dt)
			if dtotal < 0.25 then
				player.quad = left_stand
			else
				player.quad = left_step
			end
		end
	end
	if love.keyboard.isDown('right','f') then
		if player.x < (love.graphics.getWidth() - width*scale) then
			player.x = player.x + (player.speed*dt)
			if dtotal < 0.25 then
				player.quad = right_stand
			else
				player.quad = right_step
			end
		end
	end
	if love.keyboard.isDown('down','d') then
		if player.y < (love.graphics.getHeight() - height*scale) then
			player.y = player.y + (player.speed*dt)
			if dtotal < 0.25 then
				player.quad = down_step1
			else
				player.quad = down_step2
			end
		end
	end
	if love.keyboard.isDown('up','e') then
		if player.y > 0 then
			player.y = player.y - (player.speed*dt)
			if dtotal < 0.25 then
				player.quad = up_step1
			else
				player.quad = up_step2
			end
		end
	end
end


function love.draw(dt)
	love.graphics.draw(player.img, player.quad, player.x, player.y, 0, 4, 4)
end
