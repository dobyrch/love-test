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


function Static:iter(table, coords, i)
	while true do
		if not coords then
			return nil
		end

		local e = self.instances[coords][i]
		if e then
			return e, coords, i+1
		end

		coords = next(table, coords)
		i = 1
	end
end


function Static:iterAll()
	local coords = next(self.instances)
	local i = 1

	return function()
		e, coords, i = self:iter(self.instances, coords, i)
		return e
	end
end


function Static:iterNear(other)
	local i = math.floor(other.x / TILE_WIDTH)
	local j = math.floor(other.y / TILE_WIDTH)
	local nearby = {}
	local coords

	for i = i, i+1 do
		for j = j, j+1 do
			coords = i .. ',' .. j

			if self.instances[coords] then
				nearby[coords] = true
			end
		end
	end

	local coords = next(nearby)
	local k = 1

	return function()
		e, coords, k = self:iter(nearby, coords, k)
		return e
	end
end


return Static
