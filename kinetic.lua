Kinetic = Entity:subclass{instances={}}


function Kinetic:init()
	self:inherit()
	self.instances[self] = true
end
