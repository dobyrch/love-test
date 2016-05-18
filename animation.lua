local Animation = subclass(Object, {images={}})
setmetatable(Animation.images, {__mode='v'})


-- All sprites are 16x16 pixels
local DIM = 16


function Animation:new(filename, ...)
	local instance = self:super()
	instance.down = {}
	instance.up = {}
	instance.right = {}
	instance.left = {}
	instance.frame = 1
	instance.time = 0
	instance.timings = {...}

	if #instance.timings == 0 then
		instance.timings = {0.250}
	end

	if self.images[filename] then
		instance.image = self.images[filename]
	else
		instance.image = love.graphics.newImage('assets/' .. filename)
		instance.image:setFilter('linear', 'nearest')
		self.images[filename] = instance.image
	end

	local dir = {'down', 'up', 'right', 'left'}
	local width, height = instance.image:getDimensions()

	for i = 1, height/DIM do
		for j = 1, width/DIM do
			table.insert(instance[dir[i]],
				love.graphics.newQuad(
					(j - 1)*DIM, (i - 1)*DIM,
					DIM, DIM,
					width, height
				)
			)
		end
	end

	while #instance.timings < width/DIM do
		print(#instance.timings)
		table.insert(instance.timings, instance.timings[#instance.timings])
	end

	return instance
end


function Animation:update(dt)
	--[[
	print('time:', self.time, self.time + dt)
	print('timing:', self.timings[self.frame])
	print()
	--]]
	local ready = self.time < self.timings[self.frame]
		and self.time + dt >= self.timings[self.frame]

	if ready then
		self.frame = self.frame % #self.down + 1
	end

	self.time = (self.time + dt) % self.timings[#self.timings]
end


function Animation:getFrame(dir)
	return self.image, self[dir][self.frame]
end


return Animation
