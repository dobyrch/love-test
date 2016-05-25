TallGrass = subclass(Static)


function TallGrass:init(x, y)
	self:inherit(x, y)
	self.animation = Animation:new('tallgrass.png')
end
