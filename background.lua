local Background = {}

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
	['[]'] = 'door',
	['~~'] = 'roof',
}

local map = [[
^m| ==============  
-- |!!!!!!!!!!!!!!| 
   |!!,,,,,,,,<^^>,,
  **!!,,~~~~~~m^^m,,
   |!!,,()[](),,!!| 
   |!!,,,,::,,,,!!| 
___|!!!!!!::!!!!!!| 
::::::::::::|-----  
----========__**__  
]]

map = map:gsub('\n', '')



function Background:new(tiles)

	self.images = {}
	for k, v in pairs(palette) do
		self.images[k] = love.graphics.newImage('assets/' .. v .. '.png')
		self.images[k]:setFilter('linear', 'nearest')
	end

	return self
end


local sixteen = love.graphics.newQuad(0, 0, 16, 16, 16, 16)
function Background:draw()
	local row, col = 0, 0
	map:gsub('..',
		function(tile)
			love.graphics.draw(self.images[tile], sixteen, col*16, row*16)
			col = (col + 1) % 10
			if col == 0 then
				row = row+1
			end
		end
	)
end


return Background
