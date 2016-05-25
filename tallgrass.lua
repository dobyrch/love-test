TallGrass = subclass(Static)


function TallGrass:new(x, y)
	local instance = self:inherit(x, y)
	instance.animation = Animation:new('tallgrass.png')
end
