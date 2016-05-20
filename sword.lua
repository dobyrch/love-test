local subclass = require 'subclass'
local Animation = require 'animation'
local Kinetic = require 'kinetic'


local Sword = subclass(Kinetic)


function Sword:new()
	local instance = self:super('sword.png')
	instance.damage = 1
	instance.animation = Animation:new('sword.png')
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
