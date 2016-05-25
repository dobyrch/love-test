Background = subclass(Object, {speed=200})

local palette = {
	['**'] = 'flower',
	['  '] = 'grass',
	['--'] = 'grass_top',
	['__'] = 'grass_bot',
	[' |'] = 'grass_right',
	['| '] = 'grass_left',
	['|-'] = 'grass_topleft',
	['-|'] = 'grass_topright',
	['|_'] = 'grass_botleft',
	['_|'] = 'grass_botright',
	['=='] = 'grass_strip',
	[',,'] = 'grass_light',
	['!!'] = 'fence',
	['<^'] = 'tree_topleft',
	['^>'] = 'tree_topright',
	['m^'] = 'tree_botleft',
	['^m'] = 'tree_botright',
	['::'] = 'path',
	['()'] = 'window',
	['@d'] = 'door',
	['@t'] = 'treedoor',
	['~~'] = 'roof',
	['##'] = 'graytile',
	['xx'] = 'redtile',
	['??'] = 'phone',
}

local types = {
	fence = Solid,
	phone = Solid,
	roof = Solid,
	tree_botleft = Solid,
	tree_botright = Solid,
	tree_topleft = Solid,
	tree_topright = Solid,
	window = Solid,
}


function Background:new(map, x, y)
	instance = self:inherit()
	instance.tiles = {}
	instance.map = map
	instance.x = x or 1
	instance.y = y or 1
	instance.dx = 0
	instance.dy = 0
	instance.distance = 0
	instance.scrolling = false

	local textmap = require(string.format('maps/%s_%d-%d', map, x, y))
	textmap = textmap:gsub('\n', '')

	local row, col = 0, 0
	textmap:gsub('..',
		function(t)
			local tilename = palette[t]
			local tile = (types[tilename] or Tile):new()

			tile.animation = Animation:new(tilename .. '.png')

			if t == '**' then
				tile.scheduler = Scheduler:new(
					{0.4},
					{function() tile.animation:nextFrame() end},
					true
				)
			end

			col = col % GW + 1
			if col == 1 then
				row = row + 1
				instance.tiles[row] = {}
			end

			tile.x = (col - 1)*TS
			tile.y = (row - 1)*TS
			instance.tiles[row][col] = tile
		end
	)
	return instance
end


function Background:scroll(dir)
	self.dx, self.dy = util.dirVector(dir)
	self.nextmap = Background:new(self.map, self.x + self.dx, self.y + self.dy)
	self.canvas = love.graphics.newCanvas(SW, SH)
	self.scrolling = true
end


function Background:update(dt)
	-- TODO: Store only one instance of each tile; update each once
	for i = 1, GH do
		for j = 1, GW do
			local scheduler = self.tiles[i][j].scheduler
			if scheduler then
				scheduler:update(dt)
			end
		end
	end

	if self.scrolling then
		self.distance = self.distance + dt*self.speed

		if self.distance >= math.abs(self.dx*WW + self.dy*WH) then
			for k, v in pairs(self.nextmap) do
				self[k] = v
			end
		end
	end
end


function Background:collide(e)
	local i = math.ceil(e.y / TS)
	local j = math.ceil(e.x / TS)

	for i = math.max(i, 1), math.min(i+1, GH) do
		for j = math.max(j, 1), math.min(j+1, GW) do
			e:collide(self.tiles[i][j])
		end
	end
end


function Background:draw()
	for i = 1, GH do
		for j = 1, GW do
			local tile = self.tiles[i][j]
			local image, quad = tile.animation:getFrame()
			love.graphics.draw(image, quad,
				tile.x - self.dx*self.distance,
				tile.y - self.dy*self.distance
			)

		end
	end

	if self.nextmap then
		love.graphics.setCanvas(self.canvas)
		self.nextmap:draw()
		love.graphics.setCanvas()

		love.graphics.draw(self.canvas,
			(WW - self.distance)*self.dx,
			(WH - self.distance)*self.dy,
			0, 1/SCALE, 1/SCALE
		)

	end
end
