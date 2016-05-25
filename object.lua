Object = subclass(nil)


function Object:init(...)
end


function Object:super()
	return getmetatable(self).__index
end


local class
function Object:inherit(...)
	if not class then
		class = self:super()
	end

	while class and not rawget(class, 'init') do
		class = class:super()
	end

	class = class and class:super()

	if class then
		class.init(self, ...)
		class = nil
	end
end


function Object:new(...)
	local instance = {}

	setmetatable(instance, {__index=self})
	instance:init(...)

	return instance
end
