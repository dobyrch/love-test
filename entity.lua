subclass = require 'subclass'
Object = require 'object'


local Entity = subclass(Object, {images={}})


-- TODO: Pass arguments as table?
-- Entity:new{
-- 	image='file.png',
-- 	quads=8,
-- 	x=70,
-- 	y=70,
-- 	width=16,
-- 	height=16
-- }
function Entity:new(image, quads, x, y, width, height)
	local instance = self:super()

	instance.x = x
	instance.y = y
	instance.width = width
	instance.height = height
	instance.q = 1
	instance.quads = {}
	instance.timers = {}

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


function Entity:center()
	return self.x + self.width/2, self.y + self.height/2
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


function Entity:draw()
	love.graphics.setShader(self.shader)
	love.graphics.draw(self.image, self.quads[self.q], self.x, self.y)
	love.graphics.setShader(nil)

end


function Entity:update(dt)
	if self.action then
		self.time = self.time + dt
		self:action_func(dt)
	end
end


function Entity:setAction(action, ...)
	local action_func = self[action]
	local args = {...}

	if action_func then
		if self.action then
			self.timers[self.action] = self.time
		end

		self.time = self.timers[action] or 0
		self.action = action

		self.action_func = function(self, dt)
			action_func(self, dt, unpack(args))
		end
	else
		error('Unknown action "' .. action .. '"', 2)
	end
end


function Entity:callAction(action, dt, ...)
	local saved_action = self.action
	local saved_func = self.action_func

	self:setAction(action, ...)
	self.time = self.time + dt
	self:action_func(dt)

	self:setAction(saved_action)
	self.action_func = saved_func
end


function Entity:bump(dt, other)
	local cx, cy, ocx, ocy, mag, xmag, ymag

	cx, cy = self:center()
	ocx, ocy = other:center()

	mag = math.sqrt((cx - ocx)^2 + (cy - ocy)^2)
	xmag = (cx - ocx)/mag
	ymag = (cy - ocy)/mag

	self.x = self.x + dt*xmag*self.speed*4/3
	self.y = self.y + dt*ymag*self.speed*4/3
end


return Entity
