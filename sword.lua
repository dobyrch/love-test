Sword = subclass(Kinetic)


function Sword:new()
	local instance = self:inherit()
	instance.animation = Animation:new('sword.png')
	return instance
end
