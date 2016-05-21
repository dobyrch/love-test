local subclass = require 'subclass'
local Entity = require 'entity'

local TILE_WIDTH = 16

local Static = subclass(Entity, {instances={}})


function Static:new(x, y)
	local instance = self:inherit()
	instance.x = x
	instance.y = y

	local i, j
	i = math.floor(x / TILE_WIDTH)
	j = math.floor(y / TILE_WIDTH)


	local coords = i .. ',' .. j
	if self.instances[coords] then
		table.insert(self.instances[coords], instance)
	else
		self.instances[coords] = {instance}
	end

	return instance
end


function Static:nearby(other)
	local i, j
	i = math.floor(other.x / TILE_WIDTH)
	j = math.floor(other.y / TILE_WIDTH)

	local results = {}
	for i = i, i+1 do
		for j = j, j+1 do
			local coords = i .. ',' .. j
			local statics = self.instances[coords]

			if statics then
				for _, v in ipairs(statics) do
					table.insert(results, v)
				end
			end
		end
	end

	return results
end


return Static
