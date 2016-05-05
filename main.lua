player = { x = 200, y = 200, speed = 150, img = nil }


function love.load(arg)
	player.img = love.graphics.newImage('assets/link.png')
end


function love.update(dt)
	if love.keyboard.isDown('q') then
		love.event.push('quit')
	end

	if love.keyboard.isDown('left','s') then
		if player.x > 0 then
			player.x = player.x - (player.speed*dt)
		end
	end
	if love.keyboard.isDown('right','f') then
		if player.x < (love.graphics.getWidth() - player.img:getWidth()) then
			player.x = player.x + (player.speed*dt)
		end
	end
	if love.keyboard.isDown('down','d') then
		if player.y < (love.graphics.getHeight() - player.img:getHeight()) then
			player.y = player.y + (player.speed*dt)
		end
	end
	if love.keyboard.isDown('up','e') then
		if player.y > 0 then
			player.y = player.y - (player.speed*dt)
		end
	end
end


function love.draw(dt)
	love.graphics.draw(player.img, player.x, player.y)
end
