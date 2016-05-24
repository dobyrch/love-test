local subclass = require 'subclass'
local Object = require 'object'

local Animation = subclass(Object, {images={}})


-- All sprites are 16x16 pixels
local DIM = 16


function Animation:new(filename)
	local instance = self:inherit()
	instance.down = {}
	instance.up = {}
	instance.right = {}
	instance.left = {}
	instance.frame = 1

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

	return instance
end


function Animation:nextFrame()
	self.frame = self.frame % #self.down + 1
end


function Animation:getFrame(dir)
	return self.image, self[dir or 'down'][self.frame]
end


return Animation
