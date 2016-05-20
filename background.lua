local Animation = require 'animation'
local Static = require 'static'
local Scheduler = require 'scheduler'


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

local solid = {
	fence = true,
	tree_topleft = true,
	tree_topright = true,
	tree_botleft = true,
	tree_botright = true,
	window = true,
	roof = true,
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



function Background:new()
	self.tiles = {}
	for k, v in pairs(palette) do
		self.tiles[k] = Animation:new(v .. '.png')
	end

	local row, col = 0, 0
	map:gsub('..',
		function(t)
			local static = Static:new(col*16, row*16)
			static.animation = Animation:new(palette[t] .. '.png')
			static.solid = solid[palette[t]]

			if t == '**' then
				static.scheduler = Scheduler:new(
					{0.4},
					{function() static.animation:nextFrame() end},
					true
				)
			end

			col = (col + 1) % 10
			if col == 0 then
				row = row+1
			end
		end
	)
end


return Background
