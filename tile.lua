Tile = subclass(Object)

function Tile:init(name)
	self:inherit()
	self.animation = Animation:new(name .. '.png')
end
