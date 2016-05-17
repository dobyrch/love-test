local Object = {}


function Object:new()
	return {}
end


function Object:super(...)
	instance = getmetatable(self).__index:new(...)
	setmetatable(instance, {__index=self})
	return instance
end


return Object
