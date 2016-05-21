local subclass = require 'subclass'
local Animation = require 'animation'
local Kinetic = require 'kinetic'


local Sword = subclass(Kinetic)


function Sword:new()
	local instance = self:inherit()
	instance.animation = Animation:new('sword.png')
	return instance
end


return Sword
