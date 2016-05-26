require 'all'


function love.load(arg)
	mapchunk = MapChunk:new('overworld', 1, 1)
	player = Player:new()
	monster = Monster:new()
end


local walk_keys = {
	e = true, up = true,
	d = true, down = true,
	f = true, right = true,
	s = true, left = true,
}

function love.keypressed(key, scancode, isrepeat)
	if key == 'escape' then
		love.event.quit()
	elseif walk_keys[key] and player.action == 'walk' then
		player:setAction('walk')
	elseif key == 'space' or key == 'k' then
		player:setAction('swing')
	end
end


function love.keyreleased(key, scancode)
	if key == 'escape' then
		love.event.quit()
	elseif walk_keys[key] and player.action == 'walk' then
		player:setAction('walk')
	end
end


function love.update(dt)
	mapchunk:update(dt)

	if mapchunk.scrolling then
		for e in pairs(Kinetic.instances) do
			e.x = e.x - mapchunk.dx*mapchunk.speed*dt
			e.y = e.y - mapchunk.dy*mapchunk.speed*dt

			if e == player then
				e.x = e.x + mapchunk.dx*22*dt
				e.y = e.y + mapchunk.dy*22*dt
			end
		end

		return
	end

	local outdir = player:outOfBounds()
	if outdir then
		mapchunk:scroll(outdir)
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

		mapchunk:collide(e1)
	end
end


function love.draw()
	-- TODO: Scale appropriately based on resolution
	love.graphics.scale(4, 4)

	mapchunk:draw()

	for e in Static:iterAll() do
		e:draw()
	end

	for e in pairs(Kinetic.instances) do
		e:draw()
	end
end
