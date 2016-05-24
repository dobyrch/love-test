Kinetic = subclass(Entity, {instances={}})


function Kinetic:new()
	local instance = self:inherit()
	self.instances[instance] = true
	return instance
end
