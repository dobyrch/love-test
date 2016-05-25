Tile = subclass(Object)

function Tile:new(name)
	local instance = self:inherit()

	instance.animation = Animation:new(name .. '.png')

	return instance
end
