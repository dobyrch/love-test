Object = {}
setmetatable(Object, {})


function Object:subclass(attrs)
	local class = attrs or {}
	setmetatable(class, {__index=self})
	return class
end


function Object:superclass()
	return getmetatable(self).__index
end


function Object:new(...)
	local instance = {}
	setmetatable(instance, {__index=self})
	instance:init(...)
	return instance
end


function Object:init(...)
end


local class
function Object:inherit(...)
	if not class then
		class = self:superclass()
	end

	while class and not rawget(class, 'init') do
		class = class:superclass()
	end

	class = class and class:superclass()

	if class then
		class.init(self, ...)
		class = nil
	end
end
