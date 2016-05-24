local Animation = require 'animation'
local Static = require 'static'
local Solid = require 'solid'
local Scheduler = require 'scheduler'
local subclass = require 'subclass'
local Object = require 'object'
local Tile = require 'tile'
local Entity = require 'entity'

local Background = subclass(Object, {speed=200})

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

			col = col % 10 + 1
			if col == 1 then
				row = row + 1
				instance.tiles[row] = {}
			end

			instance.tiles[row][col] = tile
		end
	)
	return instance
end


function Background:scroll(dir)
	-- TODO: Move dirVector into util
	self.dx, self.dy = Entity:dirVector(dir)
	self.nextmap = Background:new(self.map, self.x + self.dx, self.y + self.dy)
	self.scrolling = true
end


function Background:update(dt)
	-- TODO: Store only one instance of each tile; update each once

	if self.scrolling then
		self.distance = self.distance + dt*self.speed

		if self.distance >= math.abs(self.dx*160 + self.dy*128) then
			for k, v in pairs(self.nextmap) do
				self[k] = v
			end
		end
	end
end


function Background:draw()
	for i = 1, 8 do
		for j = 1, 10 do
			local tile = self.tiles[i][j]
			local image, quad = tile.animation:getFrame()
			love.graphics.draw(image, quad,
				(j - 1)*16 - self.dx*self.distance,
				(i - 1)*16 - self.dy*self.distance
			)

			if self.nextmap then
				tile = self.nextmap.tiles[i][j]
				image, quad = tile.animation:getFrame()
				love.graphics.draw(image, quad,
					(j - 1)*16 + self.dx*160 - self.dx*self.distance,
					(i - 1)*16 + self.dy*128 - self.dy*self.distance
				)
			end
		end
	end
end


return Background
