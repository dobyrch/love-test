Entity = require 'entity'


local Sword = subclass(Entity)


function Sword:new()
	local instance = self:super('sword.png', 8, 0, 0, 16, 16)
	instance.damage = 1
	return instance
end


-- TODO: don't duplicate definition of harm()
function Sword:harm(dt, other)
	if other.action ~= 'recoil' and other.alignment == 'bad' then
		other:setAction('recoil', self)
		other.health = other.health - self.damage
		print(other.health)
	end
end


return Sword
