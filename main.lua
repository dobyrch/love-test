require 'all'


function love.load(arg)
	background = Background:new('overworld', 1, 1)
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
	background:update(dt)

	if background.scrolling then
		for e in pairs(Kinetic.instances) do
			e.x = e.x - background.dx*background.speed*dt
			e.y = e.y - background.dy*background.speed*dt

			if e == player then
				e.x = e.x + background.dx*22*dt
				e.y = e.y + background.dy*22*dt
			end
		end

		return
	end

	local outdir = player:outOfBounds()
	if outdir then
		background:scroll(outdir)
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

		background:collide(e1)
	end
end


function love.draw()
	-- TODO: Scale appropriately based on resolution
	love.graphics.scale(4, 4)

	background:draw()

	for e in Static:iterAll() do
		e:draw()
	end

	for e in pairs(Kinetic.instances) do
		e:draw()
	end
end
