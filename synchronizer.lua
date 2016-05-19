local subclass = require 'subclass'
local Object = require 'object'

local Synchronizer = subclass(Object)


function Synchronizer:new(animation, ...)
	local instance = self:super()
	instance.animation = animation
	instance.functions = {...}
	instance.time = 0
	instance.tind = 1
	instance.functions[1]()
	return instance
end


function Synchronizer:update(dt)
	self.time = self.time + dt

	while self.time > self.animation.timings[self.tind] do
		self.functions[self.tind+1]()
		self.time = self.time - self.animation.timings[self.tind]
		self.tind = self.tind % #self.animation.timings +1
	end
end


return Synchronizer
