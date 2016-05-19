local subclass = require 'subclass'
local Object = require 'object'

local Animation = subclass(Object, {images={}})


-- All sprites are 16x16 pixels
local DIM = 16


function Animation:new(filename, ...)
	local instance = self:super()
	instance.down = {}
	instance.up = {}
	instance.right = {}
	instance.left = {}
	instance.frame = 1
	instance.tind = 1
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
		table.insert(instance.timings, instance.timings[#instance.timings])
	end

	return instance
end


function Animation:update(dt)
	self.time = self.time + dt

	while self.time > self.timings[self.tind] do
		self.frame = self.frame % #self.down + 1
		self.time = self.time - self.timings[self.tind]
		self.tind = self.tind % #self.timings + 1
	end
end


function Animation:getFrame(dir)
	return self.image, self[dir][self.frame]
end


function Animation:getLength()
	local length = 0

	for i, t in ipairs(self.timings) do
		length = length + t
	end

	return length
end


return Animation
