Entity = require 'entity'


local Sword = subclass(Entity)


function Sword:new()
	local instance = self:super('sword.png', 8, 0, 0, 16, 16)
	instance.damage = 1
	instance.animation = Animation:new('sword.png', 0.033, 0.083, 0.217)
	return instance
end


-- TODO: don't duplicate definition of harm()
function Sword:harm(dt, other)
	if other.action ~= 'recoil' and other.alignment == 'bad' then
		other:setAction('recoil', self)
		other.health = other.health - self.damage
	end
end


return Sword
