Static = Entity:subclass{instances={}}


function Static:init(i, j)
	self:inherit()

	self.i = i
	self.j = j
	self.x = (i - 1)*TS
	self.y = (j - 1)*TS

	local coords = i .. ',' .. j
	self.coords = coords

	if self.instances[coords] then
		table.insert(self.instances[coords], self)
	else
		self.instances[coords] = {self}
	end
end


function Static:remove()
	local instances = self.instances[self.coords]

	for i, v in ipairs(instances) do
		if v == self then
			table.remove(instances, i)
			break
		end
	end
end


function Static:iter(table, coords, i)
	while true do
		if not coords then
			return nil
		end

		local e = self.instances[coords][i]
		if e then
			return e, coords, i+1
		end

		coords = next(table, coords)
		i = 1
	end
end


function Static:iterAll()
	local coords = next(self.instances)
	local i = 1

	return function()
		e, coords, i = self:iter(self.instances, coords, i)
		return e
	end
end


function Static:iterNear(other)
	local i = math.floor(other.x / TS) + 1
	local j = math.floor(other.y / TS) + 1
	local nearby = {}
	local coords

	for i = i, i+1 do
		for j = j, j+1 do
			coords = i .. ',' .. j

			if self.instances[coords] then
				nearby[coords] = true
			end
		end
	end

	local coords = next(nearby)
	local k = 1

	return function()
		e, coords, k = self:iter(nearby, coords, k)
		return e
	end
end
