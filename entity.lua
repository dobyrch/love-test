Object = require 'object'

local Entity = {images={}}
setmetatable(Entity, {__index=Object})


function Entity:new(image, quads, x, y, width, height)
	local instance
	instance = {quads={}}
	self.__index = self
	setmetatable(instance, self)

	instance.x = x
	instance.y = y
	instance.width = width
	instance.height = height

	if self.images[image] then
		instance.image = self.images[image]
	else
		instance.image = love.graphics.newImage('assets/' .. image)
		instance.image:setFilter('linear', 'nearest')
		self.images[image] = instance.image
	end

	sw, sh = instance.image:getDimensions()

	for i = 1, quads do
		instance.quads[i] = love.graphics.newQuad(
			i + (i - 1)*width, 0,
			width, height,
			sw, sh
		)
	end

	return instance
end


function Entity:inBounds()
	return self.x > 0 and self.y > 0 and
		self.x < 160 - self.width and
		self.y < 144 - self.height
end


-- TODO: check if both entities are collidable
function Entity:collides(other, buffer)
	buffer = buffer or 0

	return not (
		self.x > other.x + other.width - buffer or
		other.x > self.x + self.width - buffer or
		self.y > other.y + other.height - buffer or
		other.y > self.y + self.height - buffer
	)
end


return Entity
