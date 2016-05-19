shader = require 'shader'
subclass = require 'subclass'
Object = require 'object'
Animation = require 'animation'



local Entity = subclass(Object, {
	instances = {},
	dirs = {
		'down', 'up', 'right', 'left',
		down = {0, 1},
		up = {0, -1},
		right = {1, 0},
		left = {-1, 0}
	},
	alignment = 'neutral',
})


-- TODO: Pass arguments as table?
-- Entity:new{
-- 	image='file.png',
-- 	quads=8,
-- 	x=70,
-- 	y=70,
-- 	width=16,
-- 	height=16
-- }
function Entity:new()
	local instance = self:super()
	self.instances[instance] = true

	instance.x = 0
	instance.y = 0
	instance.width = 16
	instance.height = 16
	instance.dir = 'down'
	instance.buffer = 0
	instance.time = 0
	instance.tmp = {}

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
function Entity:intersects(other)
	return not (
		self.x > other.x + other.width - self.buffer or
		other.x > self.x + self.width - self.buffer or
		self.y > other.y + other.height - self.buffer or
		other.y > self.y + self.height - self.buffer
	)
end


function Entity:collide(dt, other)
	if self.harm and other.harmable then
		self:harm(dt, other)
	end
end


function Entity:recoil(dt, other)
	-- TODO: Create Shader obj with its own timer;
	-- shader persists across setAction()
	if not dt then
		self.shader = shader.damaged
	end

	self.shader:send('time', self.time)

	if self.time < 0.300 then
		self:callAction('bump', dt, other)
	elseif self.time < 0.800 then
		self:callAction('walk', dt)
	else
		self.shader = nil
		self:setAction('walk')
	end
end


function Entity:draw()
	if self.animation then
		love.graphics.setShader(self.shader)
		local image, quad = self.animation:getFrame(self.dir)
		love.graphics.draw(image, quad, self.x, self.y)
		love.graphics.setShader(nil)
	end

end


function Entity:update(dt)
	if self.action then
		self:action_func(dt)
	end
	if self.animation then
		self.animation:update(dt)
	end
end


function Entity:setAction(action, ...)
	local action_func = self[action]
	local args = {...}

	if action_func then
		self.action = action
		self.time = 0

		for k, v in pairs(self.tmp) do
			self.instances[v] = nil
			self.tmp[k] = nil
		end

		-- First call to action func with time == 0 gives action
		-- a chance to set up (create animations, subentities, etc)
		action_func(self, nil, ...)

		self.action_func = function(self, dt)
			self.time = self.time + dt
			action_func(self, dt, unpack(args))
		end
	else
		error('Unknown action "' .. action .. '"', 2)
	end
end


function Entity:callAction(action, dt, ...)
	local saved_action = self.action
	local saved_func = self.action_func
	local saved_time = self.time
	local saved_tmp = self.tmp

	self[action](self, dt, ...)
	--self:setAction(action, ...)
	--self:action_func(dt)

	--self:setAction(saved_action)
	self.action_func = saved_func
	self.time = saved_time
	self.tmp = saved_tmp
end


function Entity:bump(dt, other)
	if not dt then
		return
	end

	local cx, cy, ocx, ocy, mag, xmag, ymag

	cx, cy = self:center()
	ocx, ocy = other:center()

	mag = math.sqrt((cx - ocx)^2 + (cy - ocy)^2)
	xmag = (cx - ocx)/mag
	ymag = (cy - ocy)/mag

	local oldx, oldy = self.x, self.y

	self.x = self.x + dt*xmag*self.speed*4/3
	if not self:inBounds() then
		self.x = oldx
	end

	self.y = self.y + dt*ymag*self.speed*4/3
	if not self:inBounds() then
		self.y = oldy
	end
end


function Entity:setDir(dir)
	if not dir then
		self.dir = self.dirs[math.random(#self.dirs)]
	elseif self.dirs[dir] then
		self.dir = dir
	else
		error('Unknown dir "' .. dir '"', 2)
	end
end


function Entity:dirVector()
	return unpack(self.dirs[self.dir])
end


return Entity
