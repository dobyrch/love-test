local Effect = require 'effect'
local subclass = require 'subclass'
local Object = require 'object'
local Animation = require 'animation'


local Entity = subclass(Object, {
	dirs = {
		'down', 'up', 'right', 'left',
		down = {0, 1},
		up = {0, -1},
		right = {1, 0},
		left = {-1, 0}
	},
})


function Entity:new()
	local instance = self:inherit()

	instance.width = 16
	instance.height = 16
	instance.dir = 'down'
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


-- TODO: Use individual buffer for each side
function Entity:intersects(other)
	local xbuf = (self.xbuf or 0) + (other.xbuf or 0)
	local ybuf = (self.ybuf or 0) + (other.ybuf or 0)

	return not (
		self.x > other.x + other.width - xbuf or
		other.x > self.x + self.width  - xbuf or
		self.y > other.y + other.height - ybuf or
		other.y > self.y + self.height - ybuf
	)
end


function Entity:normal(other)
	local xbuf = (self.xbuf or 0) + (other.xbuf or 0)
	local ybuf = (self.ybuf or 0) + (other.ybuf or 0)

	local dx = math.abs(self.x - other.x) + xbuf
	local dy = math.abs(self.y - other.y) + ybuf

	if dx > dy then
		if self.x > other.x then
			return 1, 0
		else
			return -1, 0
		end
	elseif dy > dx then
		if self.y > other.y then
			return 0, 1
		else
			return 0, -1
		end
	else
		return (self.x > other.x) and 1 or -1,
			(self.y > other.y) and 1 or -1
	end
end


-- TODO: Perhaps this sould be moved into main.lua or reactions.lua
--       Might also be more appropriate to call it 'react' or 'resolve'
function Entity:collide(other)
	local react
	local class = other:super()

	while not react and class do
		react = self[class]
		class = class:super()
	end

	if react then
		react(self, other)
	end
end


function Entity:recoil(dt, other)
	if not dt then
		self.effect = Effect:new('damaged', 0.800)
	end

	if self.time < 0.300 then
		self:callAction('bump', dt, other)
	elseif self.time < 0.800 then
		self:setAction('walk')
	end
end


function Entity:draw()
	if self.animation then
		love.graphics.setShader(self.effect and self.effect.shader)
		local image, quad = self.animation:getFrame(self.dir)
		love.graphics.draw(image, quad, self.x, self.y)
		love.graphics.setShader(nil)
	end

end


function Entity:update(dt)
	if self.action then
		self:action_func(dt)
	end

	if self.scheduler then
		self.scheduler:update(dt)
	end

	if self.effect then
		self.effect:update(dt)
	end
end


function Entity:setAction(action, ...)
	local action_func = self[action]
	local args = {...}

	if action_func then
		self.action = action
		self.time = 0

		for k, v in pairs(self.tmp) do
			-- TODO: Should this function be moved into Kinetic?
			self.instances[v] = nil
			self.tmp[k] = nil
		end

		-- First call to action func with dt == nil gives action
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


-- TODO: Add mask so some actions can't be interrupted by others
-- TODO: Check that action is valid (see setAction)
function Entity:callAction(action, dt, ...)
	local saved_action = self.action
	local saved_func = self.action_func
	local saved_time = self.time
	local saved_tmp = self.tmp

	self[action](self, dt, ...)
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

	self.x = self.x + dt*xmag*80
	if not self:inBounds() then
		self.x = oldx
	end

	self.y = self.y + dt*ymag*80
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
