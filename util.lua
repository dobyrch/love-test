util = {}


function util.round(num)
	local int, frac = math.modf(num)

	return frac < 0.5 and int or int + 1
end


util.dirs = {
	'down', 'up', 'right', 'left',
	down = {0, 1},
	up = {0, -1},
	right = {1, 0},
	left = {-1, 0}
}

function util.dirVector(dir)
	return unpack(util.dirs[dir])
end
