local subclass = require 'subclass'

local Object = subclass(nil)


function Object:super()
	return getmetatable(self).__index
end


function Object:inherit(...)
	local instance
	local class = self

	while class and not rawget(class, 'new') do
		class = class:super()
	end

	class = class and class:super()

	if class then
		instance = class:new(...)
	else
		instance = {}
	end

	setmetatable(instance, {__index=self})
	return instance
end


function Object:new(...)
	return self:inherit(...)
end


return Object
