local util = {}

function util.round(num)
	local int, frac = math.modf(num)

	return frac < 0.5 and int or int + 1
end

return util
