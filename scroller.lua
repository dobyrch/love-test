subclass = require 'subclass'
Object = require 'object'
Entity = require 'entity'
util = require 'util'

local Scroller = subclass(Object, {speed=200})


function Scroller:new(dir)
	instance = self:inherit()
	instance.dir = dir
	instance.dx, instance.dy = Entity:dirVector(dir)
	self.distance = 0
	return instance
end


function Scroller:update(dt)
	self.distance = self.distance + self.speed*dt

	for e in pairs(Kinetic.instances) do
		e.x = e.x - self.dx*self.speed*dt
		e.y = e.y - self.dy*self.speed*dt
	end

	-- TODO: Update registry of static coords
	for e in Static:iterAll() do
		e.x = e.x - self.dx*self.speed*dt
		e.y = e.y - self.dy*self.speed*dt
	end

	if (self.dir == 'up' or self.dir == 'down') and self.distance >= 128
	or (self.dir == 'right' or self.dir == 'left') and self.distance >= 144
	then
		-- Adjust static tiles to the nearest 16x16 square
		for e in Static:iterAll() do
			e.x = util.round(e.x / 16) * 16
			e.y = util.round(e.y / 16) * 16
		end

		-- Make sure the player is in bounds to avoid
		-- triggering another screen scroll
		local outdir = player:outOfBounds()
		while outdir do
			local dx, dy = Entity:dirVector(outdir)
			player.x = player.x - dx*0.01
			player.y = player.y - dy*0.01
			outdir = player:outOfBounds()
		end

		self.done = true
	end
end


return Scroller
