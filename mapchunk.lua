MapChunk = subclass(Object, {speed=200})

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
	flower = Flower,
}


function MapChunk:init(map, x, y)
	self:inherit()
	self.tiles = {}
	self.map = map
	self.x = x or 1
	self.y = y or 1
	self.dx = 0
	self.dy = 0
	self.distance = 0
	self.scrolling = false
	self.nextmap = false

	local textmap, initmap = unpack(require(string.format(
		'maps/%s_%d-%d', map, x, y
	)))

	if initmap then
		initmap()
	end

	textmap = textmap:gsub('\n', '')

	local row, col = 0, 0
	textmap:gsub('..',
		function(t)
			local tilename = palette[t]
			local tile = (types[tilename] or Tile):new(tilename)

			col = col % GW + 1
			if col == 1 then
				row = row + 1
				self.tiles[row] = {}
			end

			tile.x = (col - 1)*TS
			tile.y = (row - 1)*TS
			self.tiles[row][col] = tile
		end
	)
end


function MapChunk:scroll(dir)
	local statics = Static.instances
	local kinetics = Kinetic.instances

	Static.instances = {}
	Kinetic.instances = {}

	self.dx, self.dy = util.dirVector(dir)
	self.nextmap = MapChunk:new(self.map, self.x + self.dx, self.y + self.dy)

	self.canvas = love.graphics.newCanvas(SW, SH)
	love.graphics.setCanvas(self.canvas)

	self.nextmap:draw()

	for e in Static:iterAll() do
		e:draw()
	end

	for e in pairs(Kinetic.instances) do
		e:draw()
	end

	love.graphics.setCanvas()
	self.nextmap.statics = Static.instances
	self.nextmap.kinetics = Kinetic.instances
	Static.instances = statics
	Kinetic.instances = kinetics

	self.scrolling = true
end


function MapChunk:update(dt)
	-- TODO: Store only one instance of each tile; update each once
	for j = 1, GH do
		for i = 1, GW do
			local scheduler = self.tiles[j][i].scheduler
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

			Static.instances = self.statics
			Kinetic.instances = self.kinetics
			-- TODO: Don't access player as global
			Kinetic.instances[player] = true
		end
	end
end


function MapChunk:collide(e)
	local i = math.floor(e.x / TS) + 1
	local j = math.floor(e.y / TS) + 1

	for j = math.max(j, 1), math.min(j+1, GH) do
		for i = math.max(i, 1), math.min(i+1, GW) do
			e:collide(self.tiles[j][i])
		end
	end
end


function MapChunk:draw()
	for j = 1, GH do
		for i = 1, GW do
			local tile = self.tiles[j][i]
			local image, quad = tile.animation:getFrame()
			love.graphics.draw(image, quad,
				tile.x - self.dx*self.distance,
				tile.y - self.dy*self.distance
			)

		end
	end

	if self.nextmap then
		love.graphics.draw(self.canvas,
			(WW - self.distance)*self.dx,
			(WH - self.distance)*self.dy,
			0, 1/SCALE, 1/SCALE
		)

	end
end
