local function subclass(base, attrs)
	local class = attrs or {}
	setmetatable(class, {__index=base})
	return class
end


return subclass
